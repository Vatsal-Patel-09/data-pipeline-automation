"""
Time generation only, at full scale, with no database involved.

Generation is pure CPU, so this half of the headline measurement can be taken
without any database configuration. Reports per-table wall time and rows/sec.

Usage: python bench_generate.py <orig|new> [scale] [label]
"""

import importlib.util
import json
import os
import sys
import time

SCRATCH = os.path.dirname(os.path.abspath(__file__))
PROJECT = r"D:\College stuff\sem 7\BDA\Project\data-pipeline-automation"
ORIG_DIR = os.path.join(SCRATCH, "orig")


def load(name, path, root):
    sys.path.insert(0, root)
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def main():
    which = sys.argv[1] if len(sys.argv) > 1 else "new"
    scale = float(sys.argv[2]) if len(sys.argv) > 2 else 1.0
    label = sys.argv[3] if len(sys.argv) > 3 else which

    model = os.path.join(PROJECT, "ecommerce_model.json")

    if which == "orig":
        module = load("gen", os.path.join(ORIG_DIR, "src", "data_generator.py"), ORIG_DIR)
        if scale != 1.0:
            # The original has no scale knob, so scale the model instead.
            with open(model, encoding="utf-8") as handle:
                spec = json.load(handle)
            for table in spec["tables"]:
                table["sample_size"] = max(1, int(round(table["sample_size"] * scale)))
            model = os.path.join(SCRATCH, f"_scaled_{scale}.json")
            with open(model, "w", encoding="utf-8") as handle:
                json.dump(spec, handle)
        generator = module.DataGenerator(model)
    else:
        module = load("gen", os.path.join(PROJECT, "src", "data_generator.py"), PROJECT)
        generator = module.DataGenerator(model, scale=scale)

    per_table = {}
    original_generate = generator.generate_table_data

    def timed(table_config):
        started = time.perf_counter()
        rows = original_generate(table_config)
        per_table[table_config["name"]] = (
            round(time.perf_counter() - started, 3),
            len(rows),
        )
        return rows

    generator.generate_table_data = timed

    print(f"--- {label} (scale={scale}) ---", flush=True)
    wall = time.perf_counter()
    generator.generate_all_data()
    total = time.perf_counter() - wall

    print(f"{'table':<14}{'rows':>9}{'seconds':>10}{'rows/sec':>12}")
    for name, (secs, rows) in per_table.items():
        rate = rows / secs if secs > 0 else 0
        print(f"{name:<14}{rows:>9,}{secs:>10.2f}{rate:>12,.0f}")
    rows_total = sum(r for _, r in per_table.values())
    print(f"{'TOTAL':<14}{rows_total:>9,}{total:>10.2f}"
          f"{(rows_total / total if total else 0):>12,.0f}")

    out = {
        "label": label,
        "which": which,
        "scale": scale,
        "total_s": round(total, 3),
        "rows": rows_total,
        "rows_per_s": round(rows_total / total, 1) if total else None,
        "per_table": {k: {"seconds": v[0], "rows": v[1]} for k, v in per_table.items()},
    }
    dest = os.path.join(SCRATCH, f"bench_gen_{label}_{scale}.json")
    with open(dest, "w", encoding="utf-8") as handle:
        json.dump(out, handle, indent=2)
    print(f"\nwrote {dest}", flush=True)


if __name__ == "__main__":
    main()
