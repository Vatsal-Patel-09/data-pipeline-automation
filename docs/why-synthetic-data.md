# Why this project exists

## The short version

Everything worth knowing in data engineering only becomes visible at scale. The
data that exhibits scale is held by organisations that will not release it. So
the ability to learn and practise at scale is gated by employment, and the gate
is held by the people who already hold the data.

This project removes the gate. You describe a domain once as JSON and it
produces a complete, referentially-consistent synthetic dataset at whatever
volume you ask for, materialised simultaneously into a relational database, flat
files, columnar storage and a live REST API.

## The long version

### Scale is not a bigger version of the same problem

A query plan at ten thousand rows and the same query plan at ten million rows
are different plans. PostgreSQL will switch from a nested loop to a hash join,
from a sequential scan to an index scan and back again, based on statistics that
only exist once there is enough data to have a distribution. An index that looks
pointless at small volume becomes the difference between 20 ms and 20 seconds.
Join order starts to matter. Partitioning starts to matter. So does cardinality
skew, cache residency, connection overhead, and the cost of a network round
trip.

None of that is observable on five hundred rows. You cannot reason your way to
it either, because the thresholds are specific to the planner, the hardware and
the data distribution. You have to run it.

This project's own development is the evidence. Two defects dominated its
runtime, and neither is visible at small volume:

- A foreign-key lookup that rebuilt its candidate list on every call. At 100
  rows it is invisible. At 100,400 rows it is roughly two billion dictionary
  probes and 91 of the 101 seconds of generation time.
- A load path issuing one network round trip per row. At 100 rows it is a
  second. At 85,400 rows against a database 7,000 km away it is hours.

Both were found by measuring at scale. Neither would have been found by reading
the code at small scale, and in fact neither *was* found by reading the code —
they were found by instrumenting and running.

### The data that exhibits scale is not available

To study any of the above you need data that is large, relationally structured,
and realistically distributed. Those three together are the problem.

Large and realistic exists inside companies. Amazon has the order graph. A bank
has the full ledger. A hospital network has the longitudinal patient record.
These organisations publish papers *about* operating at that scale; they do not
publish the data behind them, and they are not going to. The data is
simultaneously their competitive advantage, their regulatory liability, and
their customers' private information.

What is publicly available fails on at least one of the three axes:

| Source | Volume | Relational structure | Realistic distribution |
|---|---|---|---|
| Kaggle-style CSV dumps | small to medium | usually a single flat table | sometimes |
| `pgbench` / TPC-H / TPC-DS | arbitrary | yes | uniformly random, by design |
| Public API samples | tiny | partial | yes |
| Scraped data | medium | accidental | yes, but legally fraught |
| Hand-rolled fixtures | tiny | yes | no |

The benchmark suites are the closest, and they are deliberately synthetic in a
way that is *not* domain-shaped: TPC-H models a wholesale supplier because the
queries matter, not because anyone wants to study wholesale suppliers. You
cannot point it at lending, or logistics, or a marketplace, and you cannot teach
it that a review must be written after the product it reviews exists.

### The consequence is a knowledge asymmetry

People inside those organisations get better at operating at scale because they
can practise. Everyone outside practises on a 500-row CSV and discovers what a
ten-million-row join costs in production, on a Friday.

That asymmetry compounds. The organisations with the data attract the engineers
who understand scale, which produces more systems whose operational knowledge
stays inside, which widens the gap. An individual developer, a student, or a
three-person startup is locked out of the *understanding*, not just the data.

This is the gap the project addresses, and the reason it belongs in a Big Data
Analytics course rather than in a software-engineering one. The subject of the
course is behaviour at scale. This is an instrument for producing scale on
demand, so that behaviour can be observed.

### What the project actually provides

Describe the domain once, as JSON: tables, fields, types, relationships,
volumes. The pipeline then produces that dataset and materialises it everywhere
at once.

```json
{
  "name": "orders",
  "sample_size": 15000,
  "output_format": "api",
  "fields": [
    { "name": "id", "type": "integer", "primary_key": true, "auto_increment": true },
    { "name": "user_id", "type": "integer", "foreign_key": "users.id" },
    { "name": "total_amount", "type": "decimal", "precision": 12, "scale": 2 }
  ]
}
```

Three properties make it useful rather than merely convenient.

**Volume is a parameter, not a property of the dataset.** `--scale 1` gives
100,400 rows; `--scale 50` gives five million from the same model. This is the
one thing no public dataset can give you, and it is what lets you study the
*curve* rather than a single point. A measurement at one volume tells you almost
nothing; three measurements across two orders of magnitude tell you the shape.

**Referential integrity holds across heterogeneous destinations.** A `user_id`
in a CSV row resolves to a real row in PostgreSQL, because every destination is
materialised from one in-memory dataset rather than generated independently per
sink. This is the project's distinctive technical contribution, and after this
work PostgreSQL itself proves it: foreign keys are added *after* the bulk load,
so the server validates every generated reference in one pass and names the
offending row if any fails.

**The data is semantically coherent, not merely type-correct.** Structural
validity is easy and not very useful: a dataset where every user is an infant,
half the orders predate the accounts that placed them, and no order total
matches its line items will not teach you anything about a real query plan,
because no real query plan ever sees data shaped like that. The repair pass is
documented in [performance.md](performance.md) with before-and-after
measurements.

**No real records are ever involved.** This is a consequence rather than the
motivation, but it is a useful one: there is nothing to leak, nothing to
anonymise and no data agreement to negotiate. The same tool therefore works in
domains that legally cannot share data at all, and it produces the per-entity
records that personalisation work needs but aggregates cannot supply.

### What it is not

It is not a privacy tool. It does not learn a distribution from real data and
emit a differentially-private imitation of it; there is no real data anywhere in
the process. If you need synthetic data that is statistically faithful to a
specific private dataset, that is a different and harder problem.

It is not a benchmark suite. It produces data, not a standardised query workload
with published comparison figures.

It is not a production ELT tool. It is a coursework demonstrator, and the scope
decisions should be read in that light: correctness, measurement and clarity
matter here; multi-node horizontal scale does not.

## Further reading

| Document | Contents |
|---|---|
| [architecture.md](architecture.md) | How a run flows through the system |
| [performance.md](performance.md) | Every measurement, with method |
| [data-model.md](data-model.md) | The model-JSON contract |
| [known-issues.md](known-issues.md) | What is fixed, and what is still wrong |
