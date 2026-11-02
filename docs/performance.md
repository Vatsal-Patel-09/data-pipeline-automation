# Performance

Every number here was measured, by harnesses committed in `runs/headline/`. The
raw results are committed alongside them as JSON so the tables can be checked
rather than taken on trust.

---

## Method

Four rules, each of which exists because breaking one produced a wrong number
during this work.

**Uncontended.** Each configuration runs in its own subprocess, strictly
sequentially, with nothing else executing. This is not pedantry: the first
generation baseline taken for this project was measured while another run was
still executing on the same 8-core machine, which inflated it from 101s to 207s
and had to be retracted. See [Corrections](#corrections).

**Repeated.** At least two independent runs, with the spread reported. The clean
generation runs agreed to within 0.1%, 1.2% and 3.5%.

**Measured, not estimated.** Round trips are counted by `InstrumentedCursor`
(`src/db.py`), a proxy that increments a counter on every `execute`,
`executemany` and `copy_expert`. Byte counts are exact for COPY, taken from the
buffer position.

It deliberately does **not** count `fetchone`/`fetchall`. A plain psycopg2
cursor buffers the entire result set client-side when `execute()` returns, so
fetching is a local operation; counting it as a network round trip would inflate
the figure.

**Labelled when projected.** One figure in this document is extrapolated rather
than measured, and says so every time it appears.

### Environment

| | |
|---|---|
| CPU | Intel i5-13420H, 8 cores / 12 threads |
| RAM | 16 GB |
| GPU | NVIDIA RTX 4050 Laptop, 6 GB, compute 8.9 (Ada) |
| OS | Windows 11, Python 3.13.7 |
| Database | Supabase PostgreSQL 17.11, `aarch64`, eu-west-1 (Ireland) |
| Client location | India |
| **Median round-trip time** | **287–301 ms** |

That last row determines almost everything below. The client and the database
are roughly 7,000 km apart, so a single round trip costs about three tenths of a
second no matter how little data it carries.

---

## Headline: end to end

One full default run — schema, 100,400 records, five destinations, constraint
validation, sequence repair, row-count verification and a write probe:

| step | duration |
|---|---|
| `schema` | 3.06s |
| `generate` | 9.98s |
| `output` (load + file writes) | 35.03s |
| `finalize` (constraints, sequences, verification) | 11.75s |
| `report` | 0.01s |
| **wall clock** | **69.6s** |

Verification from that run: 7 of 7 foreign key constraints added, 0 violations,
row counts matched on every table, 6 sequences advanced, write probe passed.

For comparison, the same work before this overhaul: roughly 101 seconds of
generation plus a projected **7.2 hours** of row-at-a-time loading.

---

## Generation

### The defect

`generate_foreign_key_value` rebuilt the entire list of candidate parent ids on
every single field call:

```python
available_ids = [record[ref_field]
                 for record in self.generated_data[ref_table]
                 if ref_field in record]
return random.choice(available_ids)
```

The result is invariant for a given `(ref_table, ref_field)`. For the shipped
model this is roughly **2.0 billion dictionary probes** per run, dominated by
`order_items` at 40,000 rows against 35,000 parents across two foreign keys.

### The fix, and why it is safe

Memoized per `(table, field)`. This is behaviour-preserving rather than merely
equivalent: tables are generated in topological order, so
`generated_data[ref_table]` is complete and never mutated again before any child
reads it. The cached list is therefore the identical list in the identical
order, `random.choice` consumes the identical RNG draw, and the output is
byte-identical — verified across all six tables and all 49 fields.

The self-referencing branch is deliberately **not** cached, because it reads a
list that grows during generation. It contributes ~80,000 probes, which is noise.

### Measured

Full scale, 100,400 records, two uncontended runs:

| table | rows | before | after | speedup |
|---|---|---|---|---|
| `order_items` | 40,000 | 62.93s | 0.41s | **151.6x** |
| `reviews` | 15,000 | 24.24s | 1.74s | 13.9x |
| `orders` | 15,000 | 8.30s | 2.09s | 4.0x |
| `products` | 20,000 | 3.08s | 2.65s | 1.2x |
| `users` | 10,000 | 2.62s | 2.60s | 1.0x |
| `categories` | 400 | 0.07s | 0.05s | 1.4x |
| **total** | **100,400** | **101.24s** | **10.06s** | **10.1x** |

Throughput: 992 rows/s → 9,980 rows/s.

The important property is not the headline multiple, it is that the speedup
tracks **rows x parent-rows** and the three tables with no meaningful foreign-key
load are flat. That pattern is what distinguishes the right fix from a lucky
one:

| table | rows x parents | speedup |
|---|---|---|
| `order_items` | 40,000 x 35,000 = 1.40 B | 151.6x |
| `reviews` | 15,000 x 30,000 = 0.45 B | 13.9x |
| `orders` | 15,000 x 10,000 = 0.15 B | 4.0x |
| `products` | 20,000 x 400 = 0.008 B | 1.2x |

Without the semantic repair pass the figure is 9.23s (**11.0x**); the pass costs
about 0.8s and is on by default.

Evidence: `runs/headline/generation-benchmark.json`

---

## Load strategies

### The defect

`handle_postgresql_output` issued one `cursor.execute` per row — approximately
**85,400 sequential network round trips** for the shipped model. The problem is
not bandwidth; 85,400 rows is about 16.5 MB. The problem is 85,400 sequential
*waits*.

### Measured

Three strategies at reduced scale, where row-at-a-time is tolerable, plus the
two batched strategies at full scale:

| configuration | rows | round trips | load time | rows/s | MB sent |
|---|---|---|---|---|---|
| `rowwise` (scale 0.01) | 854 | 854 | 259.61s | 3 | — |
| `execute_values` (scale 0.01) | 854 | 5 | 2.78s | 307 | — |
| `copy` (scale 0.01) | 854 | 5 | 4.16s | 205 | 0.2 |
| `execute_values` (full) | 85,400 | 86 | 40.67s | 2,100 | — |
| `copy` (full) | 85,400 | 5 | **18.61s** | **4,590** | 16.5 |

At scale 0.01, relative to row-at-a-time: `execute_values` **93.4x**, `copy`
**62.4x**.

### Full-scale row-at-a-time, projected

Measured at reduced scale: 854 round trips in 259.61s = **0.304 s per round
trip**, which matches the 287 ms median RTT plus insert processing. Projecting
to the full 85,400-row closure:

> **85,400 round trips x 0.304s = 25,961s = 7.21 hours**

| strategy | full-scale load | vs row-at-a-time |
|---|---|---|
| `rowwise` | 7.21 hours *(projected)* | — |
| `execute_values` | 40.67s *(measured)* | **638x** |
| `copy` | 18.61s *(measured)* | **1,395x** |

The 7.21-hour figure is **projected, not measured**, and is labelled as such
everywhere it appears. A full-scale row-at-a-time run was not performed because
it would take most of a working day to produce a number already determined by
two quantities that *were* measured: the round-trip count and the per-round-trip
cost.

### Where the time actually goes

This is the most interesting result, and it confirms a prediction made before
any of it was built. Decomposing each strategy into latency (round trips x RTT)
versus data transfer:

| strategy | round trips | latency | transfer | total | latency share |
|---|---|---|---|---|---|
| `rowwise` | 85,400 | 24,510s | ~17s | 25,961s | **94%** |
| `execute_values` | 86 | 24.7s | ~16s | 40.67s | 61% |
| `copy` | 5 | 1.4s | 17.2s | 18.61s | **8%** |

So the three strategies are not three points on one curve — they are in
different regimes:

- `rowwise` is almost entirely **latency-bound**. It is waiting, not working.
- `execute_values` removes most of the waiting and lands roughly balanced.
- `copy` is almost entirely **bandwidth-bound**: 16.5 MB at an effective
  0.89 MB/s, about 7 Mbit/s of usable uplink.

Two consequences follow directly, and both were predicted:

**The large multiple is `rowwise → execute_values`, not COPY.** Batching removes
the 85,400 waits. COPY then buys a further **2.19x** (40.67s → 18.61s) by
collapsing 86 round trips to 5 and skipping server-side INSERT parsing. Real,
but an order of magnitude smaller than the first step.

**Parallel loading should be roughly flat.** `copy` is already 92%
bandwidth-bound, so splitting one uplink across N connections cannot create
bandwidth. `--parallel-loads N` exists and defaults to 1; measuring it is listed
as open work in [known-issues.md](known-issues.md), and a flat line is the
expected finding rather than a failure.

### A measured crossover

COPY is **slower** than `execute_values` at 854 rows and **2.19x faster** at
85,400:

| rows | `execute_values` | `copy` | winner |
|---|---|---|---|
| 854 | 2.78s | 4.16s | `execute_values` |
| 85,400 | 40.67s | 18.61s | `copy` |

At small volume both collapse to the same 5 round trips, so COPY's stream setup
and escaping work have nothing to amortise over. This is worth stating plainly
because it is the kind of result a benchmark run at one scale would get
backwards.

Evidence: `runs/headline/load-benchmark.json`

### Session tuning

`statement_timeout = 0` is set defensively: a multi-megabyte COPY on a slow
uplink can exceed a role-level timeout and be killed mid-stream.

`synchronous_commit = off` is set and **measured to change nothing**. This is
the knob most commonly recommended for bulk loading, and the reason it does
nothing here is instructive: once rows are batched there are five commits in the
entire run rather than one per row, so there are almost no fsyncs left to skip.

`session_replication_role = replica` — the classic trick for suppressing
constraint checks during a load — requires superuser, which Supabase's
`postgres` role is not. It is attempted, refused, and the refusal recorded in
`run_report.json` under `config.session_tuning.rejected`. Constraint *deferral*
achieves the same end without superuser, which is why it is the mechanism used.

`UNLOGGED` tables were considered and rejected: `SET LOGGED` rewrites the table
and writes back all the WAL the load avoided, and it conflicts with Supabase
replication.

---

## Data realism

Structural validity is easy and not very useful on its own. A dataset in which
every user is an infant, half the orders predate the accounts that placed them,
and no order total matches its line items will not teach you anything about a
real query plan, because no real plan ever sees data shaped like that.

Full scale, 100,400 records, semantic pass off versus on:

| metric | before | after |
|---|---|---|
| `users.birth_date` implied age | 0.0–2.0 years | 18.0–79.99 years |
| users under 18 | 10,000 / 10,000 | 0 / 10,000 |
| orders placed before the user registered | 49.8% (7,467) | 0% |
| reviews written before the product existed | 49.9% (7,479) | 0% |
| line totals != qty x price − discount | 100% (40,000) | 0% |
| order totals != sum of line items | 100% (13,969) | 0% |
| `users.total_spent` != order history | 100% (10,000) | 0% |
| `unit_price` unrelated to the product's price | 58.4% (23,368) | 0% |
| products priced at or below cost | 50.0% (9,992) | 0% |
| category names using the `_N` fallback | ~370 / 400 | 0 / 400 |
| distinct product names | 30 / 20,000 | 20,000 / 20,000 |

Four of these were already recorded in the project's defect register. Three were
not, and are arguably worse than the documented ones:

- **Line totals were also 100% wrong** — not just order totals.
- **`unit_price` bore no relationship to the product being bought.** This
  matters more than it looks: reconciling order totals while line prices are
  random is arithmetic over noise. It produces a dataset that is internally
  consistent and still describes impossible orders.
- **Half of all products were priced at or below cost.**

Every rule is driven by field names and the foreign-key graph, never by
hardcoded table names, which is what keeps the pipeline declarative. The rules
are tabulated in [data-model.md](data-model.md#relationships-from-srcrealismpy).

Cost: about 0.8s on top of 9.2s of generation, and it is on by default.

Provenance note: the `30 / 20,000` product-name figure is measured against the
**unmodified generator at the branch point**
(`runs/headline/realism-original-code.json`), so the later taxonomy-vocabulary
fix does not contaminate it. Every other "before" figure is unaffected by that
change and was taken with the pass simply disabled.

Evidence: `runs/headline/realism-before.json`,
`runs/headline/realism-after.json`, `runs/headline/realism-original-code.json`

---

## File formats

The same table — `products`, 20,000 rows x 11 fields — written to all three file
destinations. Read timings are best-of-five after a warm-up, so they measure I/O
rather than library import cost.

| format | size on disk | vs CSV | write | read all columns |
|---|---|---|---|---|
| CSV | 10.55 MB | 1.00x | 0.28s | 0.081s |
| JSON | 14.51 MB | 1.38x | 0.34s | 0.071s |
| **Parquet** | **6.32 MB** | **0.60x** | **0.23s** | **0.022s** |

Parquet is 40% smaller than CSV and 56% smaller than JSON, and faster to both
write and read. But reading every column is the case where a columnar format has
least to offer. The interesting comparison is a projection:

| operation | CSV | Parquet | speedup |
|---|---|---|---|
| read all 11 columns | 0.081s | 0.022s | 3.7x |
| read 2 of 11 columns | 0.030s | 0.002s | **15.6x** |
| aggregate 1 column | 0.029s | 0.001s | **19.6x** |

A row-oriented file has to read and parse every byte to reach one column. A
columnar file reads only the column chunks it needs. That is the entire argument
for the format, and it is why analytical tooling uses it.

A caution about how easily this gets measured wrong: the first run of this
benchmark reported Parquet reads as *slower* than CSV (0.52s vs 0.12s). That
figure was pyarrow's first-import cost, not I/O. Warming the libraries and
taking a best-of-five reversed the result by a factor of 24.

Evidence: `runs/headline/format-benchmark.json`,
`runs/headline/format-read-benchmark.json`

---

## Other measured fixes

**DDL round trips.** 6 drops + 6 creates + 7 constraint additions were sent one
statement at a time: 19 round trips, about 5.7s at this RTT. Now a single
multi-statement execute. The `schema` step takes 3.06s including connection
setup and model validation.

**Constraint validation as a feature.** Foreign keys are added after the load, so
PostgreSQL validates all seven constraints in one sequential pass instead of
85,400 per-row index probes. The run report records
`fk_constraints_added: 7, fk_violations: 0` — which is the project's central
claim, verified by the server rather than asserted by its author.

**Reproducibility.** Not a speed result, but measured: before the date-anchoring
fix, **five of six tables produced different data on every run**, and the only
stable table was precisely the one with no temporal field. Varying
`PYTHONHASHSEED` across 0–4 gave the same result, ruling out hash ordering as
the cause. After the fix, output is identical across six runs spanning six
different hash seeds.

---

## What was not built, and why

### GPU generation

The project has an RTX 4050 available and deliberately does not use it. The
reasoning, recorded before writing any CUDA-adjacent code:

**Faker cannot run on a GPU.** It is pure Python over CPython's Mersenne
Twister. There is no CUDA path and no amount of effort creates one.

**The arrays are far too small.** `rng.integers(0, 20000, 40000)` is about
200 microseconds on the CPU. A first CuPy call initialises the CUDA context in
0.5–2 **seconds** — more than the entire CPU cost of every numeric column in the
model combined.

**The remaining cost is string work.** After the foreign-key fix, generation is
about 10s of mostly string construction. CuPy cannot touch it. cuDF could help,
and has **no native Windows build** — it is WSL2 only — so on this machine the
GPU dataframe path does not exist.

**The run is not compute-bound anyway.** Generation is 10s of a 70s run. Even
reducing it to zero would improve the end-to-end figure by 14%, and the load
path that dominates is bandwidth-bound, which no GPU affects.

A vectorized NumPy engine and an opt-in CuPy engine with a measured crossover
point remain the honest way to pursue this, and are listed as open work in
[known-issues.md](known-issues.md). The expected result is explicitly that the
GPU path is *slower* at this project's scale, and that the crossover sits
somewhere around 1–10 million rows, reachable only when the destination is a
local columnar file rather than a remote database.

Stating that prediction before measuring it is the point. "We added CUDA" to a
network-bound pipeline would not survive a question.

### Parallel loading, beyond the flag

Implemented, defaults to off, not yet measured. The decomposition above predicts
it is roughly flat, because COPY is already 92% bandwidth-bound.

---

## Corrections

Two measurement errors were made during this work and are recorded because the
method matters as much as the numbers.

**A contended baseline, inflated about 2x.** The first generation baseline was
reported as 207.5s, with the fixed version at 17.5s, for an 11.9x speedup. Both
figures were taken while other work was executing on the same machine. Measured
uncontended and repeated, the real figures are 101.24s and 10.06s, for 10.1x.
The shape of the result was unchanged and still tracked rows x parent-rows, but
the magnitude was overstated and the committed evidence had to be replaced.

**A cold-start artifact, reversed by 24x.** The first format benchmark reported
Parquet reads at 0.52s against CSV's 0.12s, making Parquet look like a poor
choice. That was pyarrow's first-import cost. Warmed and repeated, Parquet reads
in 0.022s against CSV's 0.081s.

Both errors share a cause: measuring once, without controlling the environment.
Both are why the method section exists.
