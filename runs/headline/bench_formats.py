"""
File-format comparison: the same table written to CSV, JSON and Parquet.

Measures size, write time and read time for identical data, which is the
clearest way to show why columnar storage is the format big-data tooling
actually uses.
"""
import json, os, sys, time
REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, REPO)
from src.data_generator import DataGenerator
from src.output_handlers import OutputHandler

TABLE = sys.argv[1] if len(sys.argv) > 1 else "products"
export = os.path.join(REPO, "exports", "_formats")
os.makedirs(export, exist_ok=True)

model = json.load(open(os.path.join(REPO, "ecommerce_model.json"), encoding="utf-8"))
gen = DataGenerator(os.path.join(REPO, "ecommerce_model.json"))
data = gen.generate_all_data()
rows = data[TABLE]["data"]
handler = OutputHandler(model=model, export_dir=export)

results = {}
for sink, ext, writer in (
    ("csv", "csv", handler.handle_csv_output),
    ("json", "json", handler.handle_json_output),
    ("parquet", "parquet", handler.handle_parquet_output),
):
    started = time.perf_counter()
    writer(TABLE, rows, data[TABLE]["config"])
    write_s = time.perf_counter() - started
    path = os.path.join(export, sink, f"{TABLE}.{ext}")
    size = os.path.getsize(path)

    import pandas as pd
    started = time.perf_counter()
    if sink == "csv":
        pd.read_csv(path)
    elif sink == "json":
        json.load(open(path, encoding="utf-8"))
    else:
        pd.read_parquet(path)
    read_s = time.perf_counter() - started

    results[sink] = {"bytes": size, "mb": round(size / 1048576, 2),
                     "write_s": round(write_s, 3), "read_s": round(read_s, 3)}

payload = {"benchmark": "file format comparison", "table": TABLE,
           "rows": len(rows), "fields": len(rows[0]), "results": results}
out = os.path.join(REPO, "runs", "headline", "format-benchmark.json")
json.dump(payload, open(out, "w"), indent=2)

base = results["csv"]["bytes"]
print(f"{TABLE}: {len(rows):,} rows x {len(rows[0])} fields")
print()
print(f"{'format':<10}{'size':>12}{'vs CSV':>9}{'write s':>10}{'read s':>9}")
for sink, r in results.items():
    print(f"{sink:<10}{r['mb']:>10.2f}MB{r['bytes']/base:>9.2f}x"
          f"{r['write_s']:>10.2f}{r['read_s']:>9.2f}")
print()
print(f"wrote {out}")
