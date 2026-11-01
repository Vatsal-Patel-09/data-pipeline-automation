"""
The model's table graph: one canonical loader, foreign-key parser and
topological sort.

Before this module the pipeline implemented the same topological sort three
times, in database_manager, data_generator and output_handlers, and the copies
had already diverged:

  * database_manager's version iterated a set without sorting, so schema
    creation order varied with PYTHONHASHSEED.
  * output_handlers computed the PostgreSQL closure non-transitively, so a
    dependency of a dependency was silently dropped.
  * output_handlers also required a dotted foreign_key and silently ignored the
    documented bare-table shorthand, while the other two honoured it. That
    combination is a latent hard failure rather than a cosmetic gap: the DDL
    creates a real constraint and the generator produces valid values, but the
    parent is left out of the load set, so the constraint fails at load time and
    aborts the run.
  * all three broke cycles by picking an arbitrary set member, and only two of
    them logged anything about it.

Consolidating fixes all four by construction.
"""

import hashlib
import json
from dataclasses import dataclass
from typing import Any, Dict, Iterable, List, Optional, Sequence, Set, Tuple

PK_DEFAULT = "id"

OUTPUT_FORMAT_ALIASES = {
    "postgres": "postgresql",
    "postgresql": "postgresql",
    "csv": "csv",
    "json": "json",
    "api": "api",
    "parquet": "parquet",
}

DEFAULT_OUTPUT_FORMAT = "postgresql"

# Formats whose rows must exist in PostgreSQL: those that declare it, plus
# 'api', which is served from PostgreSQL by the API process.
POSTGRES_BACKED_FORMATS = ("postgresql", "api")


class ModelError(ValueError):
    """Raised when a model file violates the documented contract."""


def parse_foreign_key(fk_string: str) -> Tuple[str, str]:
    """
    Parse a foreign_key value into (table, field).

    Accepts both documented shapes: the dotted form 'categories.id' and the
    bare-table shorthand 'categories', which defaults the field to 'id'.
    """
    if not isinstance(fk_string, str) or not fk_string.strip():
        raise ModelError(
            f"foreign_key must be a non-empty string of the form "
            f"'table.field' or 'table', got {fk_string!r}"
        )
    text = fk_string.strip()
    if "." in text:
        table, field = text.split(".", 1)
        table, field = table.strip(), field.strip()
        if not table or not field:
            raise ModelError(
                f"foreign_key {fk_string!r} must name both a table and a field"
            )
        return table, field
    return text, PK_DEFAULT


def normalize_output_format(table_config: Dict[str, Any]) -> str:
    """Normalize a table's declared output_format to its canonical name."""
    declared = table_config.get("output_format", DEFAULT_OUTPUT_FORMAT)
    if not isinstance(declared, str):
        raise ModelError(
            f"output_format for table {table_config.get('name')!r} must be a "
            f"string, got {declared!r}"
        )
    key = declared.strip().lower()
    if key not in OUTPUT_FORMAT_ALIASES:
        raise ModelError(
            f"Unknown output_format {declared!r} for table "
            f"{table_config.get('name')!r}. Expected one of: "
            + ", ".join(sorted(set(OUTPUT_FORMAT_ALIASES)))
        )
    return OUTPUT_FORMAT_ALIASES[key]


@dataclass(frozen=True)
class FKRef:
    """One foreign-key edge from a child field to a parent field."""

    field: str
    ref_table: str
    ref_field: str
    nullable: bool
    self_ref: bool


class ModelGraph:
    """
    The table dependency graph for one model.

    Deliberately model-driven rather than driven by already-generated data, so
    the write plan (table order, PostgreSQL closure, parallel waves) can be
    computed before anything is generated. That is what makes a dry-run
    possible.
    """

    def __init__(self, model: Dict[str, Any]):
        if not isinstance(model, dict) or "tables" not in model:
            raise ModelError("Model must be an object containing a 'tables' key")
        raw_tables = model["tables"]
        if not isinstance(raw_tables, list):
            raise ModelError(
                "'tables' must be a list of table objects, not a mapping keyed "
                "by table name"
            )

        self.model = model
        self.database = model.get("database", {})
        self.tables: Dict[str, Dict[str, Any]] = {}

        for table_config in raw_tables:
            if not isinstance(table_config, dict) or "name" not in table_config:
                raise ModelError("Every table must be an object with a 'name'")
            name = table_config["name"]
            if name in self.tables:
                raise ModelError(f"Duplicate table name {name!r}")
            fields = table_config.get("fields")
            if not isinstance(fields, list):
                raise ModelError(
                    f"'fields' for table {name!r} must be a list of field "
                    "objects, not a mapping keyed by field name"
                )
            self.tables[name] = table_config

        self.table_names: List[str] = sorted(self.tables)
        self._fks: Dict[str, List[FKRef]] = {
            name: self._extract_fks(name) for name in self.tables
        }

    # -- construction helpers ---------------------------------------------

    @classmethod
    def from_file(cls, model_file: str) -> "ModelGraph":
        with open(model_file, "r", encoding="utf-8") as handle:
            return cls(json.load(handle))

    def _extract_fks(self, table: str) -> List[FKRef]:
        refs: List[FKRef] = []
        for field in self.tables[table].get("fields", []):
            if "foreign_key" not in field:
                continue
            ref_table, ref_field = parse_foreign_key(field["foreign_key"])
            refs.append(
                FKRef(
                    field=field["name"],
                    ref_table=ref_table,
                    ref_field=ref_field,
                    nullable=bool(field.get("nullable", False)),
                    self_ref=(ref_table == table),
                )
            )
        return refs

    def model_hash(self) -> str:
        """Stable hash of the model, so incomparable runs are never compared."""
        blob = json.dumps(self.model, sort_keys=True, separators=(",", ":"))
        return "sha256:" + hashlib.sha256(blob.encode("utf-8")).hexdigest()[:32]

    # -- queries -----------------------------------------------------------

    def __contains__(self, table: str) -> bool:
        return table in self.tables

    def __len__(self) -> int:
        return len(self.tables)

    def config(self, table: str) -> Dict[str, Any]:
        try:
            return self.tables[table]
        except KeyError:
            raise ModelError(f"No such table {table!r} in model") from None

    def output_format(self, table: str) -> str:
        return normalize_output_format(self.config(table))

    def sample_size(self, table: str, scale: float = 1.0) -> int:
        declared = self.config(table).get("sample_size", 100)
        if scale == 1.0:
            return declared
        return max(1, int(round(declared * scale)))

    def foreign_keys(self, table: str) -> List[FKRef]:
        """All foreign-key edges declared on a table, self-references included."""
        return list(self._fks[table])

    def dependencies(self, table: str, include_self: bool = False) -> List[str]:
        """
        Tables this table references, sorted and de-duplicated.

        Self-references are excluded by default because they cannot participate
        in an ordering constraint: a table cannot be created after itself.
        """
        names = {
            ref.ref_table
            for ref in self._fks[table]
            if include_self or not ref.self_ref
        }
        return sorted(names)

    def dependents(self, table: str) -> List[str]:
        """Tables that reference this one."""
        return sorted(
            name
            for name in self.tables
            if table in self.dependencies(name)
        )

    # -- ordering ----------------------------------------------------------

    def topological_order(self) -> List[str]:
        """
        Kahn's algorithm with ties broken by name, so the result is fully
        deterministic and does not depend on set iteration order.

        A dependency on a table absent from the model is treated as already
        satisfied; validate() is what reports it.
        """
        remaining: Set[str] = set(self.tables)
        deps = {
            name: {d for d in self.dependencies(name) if d in self.tables}
            for name in self.tables
        }
        ordered: List[str] = []

        while remaining:
            ready = sorted(
                name
                for name in remaining
                if not (deps[name] & remaining)
            )
            if not ready:
                # A genuine cycle. Break it deterministically at the
                # lowest-named member rather than at an arbitrary one.
                ready = [min(remaining)]
            for name in ready:
                ordered.append(name)
                remaining.discard(name)
        return ordered

    def waves(self, names: Optional[Iterable[str]] = None) -> List[List[str]]:
        """
        Group tables into dependency levels.

        Every table in wave k depends only on tables in waves < k, so all
        members of a wave can be processed concurrently.
        """
        scope: Set[str] = set(self.tables if names is None else names)
        remaining = set(scope)
        deps = {
            name: {d for d in self.dependencies(name) if d in scope}
            for name in scope
        }
        levels: List[List[str]] = []

        while remaining:
            ready = sorted(
                name for name in remaining if not (deps[name] & remaining)
            )
            if not ready:
                ready = [min(remaining)]
            levels.append(ready)
            remaining -= set(ready)
        return levels

    def closure(self, seeds: Iterable[str]) -> Set[str]:
        """
        Transitively expand a set of tables over their foreign keys.

        Runs to a fixpoint. The previous implementation expanded only one level
        from the seed set, so a dependency of a dependency was silently omitted
        from the load plan.
        """
        result: Set[str] = set()
        pending = [s for s in seeds if s in self.tables]
        while pending:
            table = pending.pop()
            if table in result:
                continue
            result.add(table)
            for dep in self.dependencies(table):
                if dep in self.tables and dep not in result:
                    pending.append(dep)
        return result

    def postgres_closure(self) -> Set[str]:
        """Every table whose rows must exist in PostgreSQL."""
        seeds = [
            name
            for name in self.tables
            if self.output_format(name) in POSTGRES_BACKED_FORMATS
        ]
        return self.closure(seeds)

    def subgraph(self, names: Iterable[str]) -> "ModelGraph":
        """A ModelGraph restricted to the named tables, preserving order."""
        wanted = set(names)
        model = dict(self.model)
        model["tables"] = [
            config
            for config in self.model["tables"]
            if config["name"] in wanted
        ]
        return ModelGraph(model)

    # -- diagnostics -------------------------------------------------------

    def cycles(self) -> List[List[str]]:
        """
        Strongly connected components of size > 1, i.e. genuine cycles.

        Self-references are legitimate (a category tree) and are not reported.
        Tarjan's algorithm, iterative so a deep graph cannot blow the stack.
        """
        index_of: Dict[str, int] = {}
        low: Dict[str, int] = {}
        on_stack: Dict[str, bool] = {}
        stack: List[str] = []
        counter = [0]
        found: List[List[str]] = []

        for root in self.table_names:
            if root in index_of:
                continue
            work: List[Tuple[str, int]] = [(root, 0)]
            while work:
                node, child_index = work[-1]
                if child_index == 0:
                    index_of[node] = low[node] = counter[0]
                    counter[0] += 1
                    stack.append(node)
                    on_stack[node] = True
                children = self.dependencies(node)
                if child_index < len(children):
                    work[-1] = (node, child_index + 1)
                    child = children[child_index]
                    if child not in self.tables:
                        continue
                    if child not in index_of:
                        work.append((child, 0))
                    elif on_stack.get(child):
                        low[node] = min(low[node], index_of[child])
                else:
                    work.pop()
                    if work:
                        parent = work[-1][0]
                        low[parent] = min(low[parent], low[node])
                    if low[node] == index_of[node]:
                        component = []
                        while True:
                            member = stack.pop()
                            on_stack[member] = False
                            component.append(member)
                            if member == node:
                                break
                        if len(component) > 1:
                            found.append(sorted(component))
        return sorted(found)

    def validate(self) -> List[str]:
        """
        Check the model against the documented contract.

        Returns a list of human-readable problems; empty means valid. Reporting
        all problems at once beats failing on the first, because a model being
        edited usually has several.
        """
        problems: List[str] = []

        for name in self.table_names:
            config = self.tables[name]
            fields = config.get("fields", [])

            if not fields:
                problems.append(f"Table '{name}' declares no fields")

            seen_fields: Set[str] = set()
            primary_keys: List[str] = []
            for field in fields:
                if not isinstance(field, dict) or "name" not in field:
                    problems.append(
                        f"Table '{name}' has a field that is not an object with a 'name'"
                    )
                    continue
                field_name = field["name"]
                if field_name in seen_fields:
                    problems.append(
                        f"Table '{name}' declares field '{field_name}' more than once"
                    )
                seen_fields.add(field_name)
                if "type" not in field:
                    problems.append(
                        f"Field '{name}.{field_name}' has no 'type'"
                    )
                if field.get("primary_key"):
                    primary_keys.append(field_name)
                if field.get("unique") and "foreign_key" in field:
                    problems.append(
                        f"Field '{name}.{field_name}' declares both 'unique' and "
                        "'foreign_key'. Foreign-key values are drawn with "
                        "replacement from the parent, so uniqueness cannot be "
                        "honoured and the DDL's UNIQUE constraint will fail at load."
                    )

            if not primary_keys:
                problems.append(f"Table '{name}' declares no primary key")
            elif len(primary_keys) > 1:
                problems.append(
                    f"Table '{name}' declares multiple primary keys: "
                    + ", ".join(primary_keys)
                )

            try:
                normalize_output_format(config)
            except ModelError as exc:
                problems.append(str(exc))

            for ref in self._fks[name]:
                if ref.ref_table not in self.tables:
                    problems.append(
                        f"Field '{name}.{ref.field}' references table "
                        f"'{ref.ref_table}', which the model does not define"
                    )
                    continue
                parent_fields = {
                    f["name"]
                    for f in self.tables[ref.ref_table].get("fields", [])
                    if isinstance(f, dict) and "name" in f
                }
                if ref.ref_field not in parent_fields:
                    problems.append(
                        f"Field '{name}.{ref.field}' references "
                        f"'{ref.ref_table}.{ref.ref_field}', which does not exist"
                    )

        for cycle in self.cycles():
            problems.append(
                "Circular foreign-key dependency among: " + ", ".join(cycle)
            )

        return problems

    def describe(self) -> Dict[str, Any]:
        """Graph facts for the run report and the dashboard."""
        order = self.topological_order()
        closure = sorted(self.postgres_closure())
        return {
            "tables": len(self.tables),
            "topological_order": order,
            "postgres_closure": closure,
            "waves": self.waves(),
            "postgres_waves": self.waves(closure),
            "cycles": self.cycles(),
            "model_hash": self.model_hash(),
            "foreign_keys": [
                {
                    "table": name,
                    "field": ref.field,
                    "references": f"{ref.ref_table}.{ref.ref_field}",
                    "nullable": ref.nullable,
                    "self_ref": ref.self_ref,
                }
                for name in self.table_names
                for ref in self._fks[name]
            ],
        }
