"""Sequential, uncontended generation benchmark. One process at a time."""
import importlib.util, json, os, subprocess, sys, time
SP = os.path.dirname(os.path.abspath(__file__))
PROJECT = r"D:\College stuff\sem 7\BDA\Project\data-pipeline-automation"

RUNNER = r'''
import importlib.util, json, os, sys, time
which, scale, realism = sys.argv[1], float(sys.argv[2]), sys.argv[3] == "1"
SP = sys.argv[4]; PROJECT = sys.argv[5]
root = os.path.join(SP, "orig") if which == "orig" else PROJECT
sys.path.insert(0, root)
spec = importlib.util.spec_from_file_location("g", os.path.join(root, "src", "data_generator.py"))
m = importlib.util.module_from_spec(spec); sys.modules["g"] = m; spec.loader.exec_module(m)
model = os.path.join(PROJECT, "ecommerce_model.json")
if which == "orig":
    gen = m.DataGenerator(model)
else:
    gen = m.DataGenerator(model, scale=scale, realism=realism)
per = {}
orig_fn = gen.generate_table_data
def timed(cfg):
    t = time.perf_counter(); rows = orig_fn(cfg)
    per[cfg["name"]] = (round(time.perf_counter() - t, 3), len(rows)); return rows
gen.generate_table_data = timed
t0 = time.perf_counter(); gen.generate_all_data(); total = time.perf_counter() - t0
print("@@R@@" + json.dumps({"per": per, "total": round(total, 3),
      "rows": sum(v[1] for v in per.values())}))
'''

def run(which, scale, realism, label):
    print(f"running {label} ...", flush=True)
    out = subprocess.run([sys.executable, "-c", RUNNER, which, str(scale),
                          "1" if realism else "0", SP, PROJECT],
                         capture_output=True, text=True, cwd=PROJECT)
    for line in out.stdout.splitlines():
        if line.startswith("@@R@@"):
            d = json.loads(line[5:]); d["label"] = label; return d
    print(out.stderr[-2500:]); sys.exit(1)

results = [
    run("orig", 1.0, False, "A. pre-overhaul (quadratic FK lookup)"),
    run("new",  1.0, False, "B. current, semantic pass OFF"),
    run("new",  1.0, True,  "C. current, semantic pass ON (default)"),
]
print()
tables = list(results[0]["per"].keys())
print(f"{'table':<14}" + "".join(f"{r['label'][:2]:>12}" for r in results))
for t in tables:
    row = f"{t:<14}"
    for r in results:
        row += f"{r['per'].get(t,(0,0))[0]:>12.2f}"
    print(row)
print(f"{'TOTAL':<14}" + "".join(f"{r['total']:>12.2f}" for r in results))
print()
for r in results:
    print(f"{r['label']:<42} {r['total']:>8.2f}s  {r['rows']/r['total']:>10,.0f} rows/s")
a = results[0]["total"]
for r in results[1:]:
    print(f"  speedup vs A: {a/r['total']:.1f}x   ({r['label']})")
json.dump(results, open(os.path.join(SP, "clean_bench.json"), "w"), indent=2)
