"""
Load-strategy benchmark against the real database.

Runs each configuration as a full pipeline invocation, strictly sequentially in
its own subprocess with nothing else executing, and reads the numbers back out
of the run report. Round trips are measured by the instrumented cursor, not
estimated.

Why some rows are extrapolated rather than measured: the row-at-a-time strategy
issues one network round trip per row. At the measured round-trip time to this
database, loading the full 85,400-row closure that way would take hours. It is
therefore measured at reduced scale, where the per-round-trip cost can be
observed directly, and the full-scale figure is computed from that cost and the
known round-trip count. Extrapolated figures are labelled as such.

Usage:
    python runs/headline/bench_load.py [--small 0.01] [--out FILE]
"""

import argparse
import json
import os
import subprocess
import sys
import time

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Tables whose rows reach PostgreSQL, and their full-scale row counts.
FULL_SCALE_PG_ROWS = 85_400


def run_once(strategy, scale, label, page_size=1000, extra=None):
    """One pipeline invocation. Returns the parsed run report."""
    report_path = os.path.join(REPO_ROOT, "runs", f"_bench_{label}.json")
    export_dir = os.path.join(REPO_ROOT, "exports")
    command = [
        sys.executable, "data_pipeline.py", "run",
        "--scale", str(scale),
        "--load-strategy", strategy,
        "--page-size", str(page_size),
        "--report", report_path,
        "--export-dir", export_dir,
    ] + (extra or [])

    print(f"  running {label} (strategy={strategy}, scale={scale}) ...", flush=True)
    started = time.perf_counter()
    completed = subprocess.run(
        command, capture_output=True, text=True, cwd=REPO_ROOT, timeout=36_000
    )
    wall = time.perf_counter() - started
    if completed.returncode != 0:
        print(completed.stdout[-3000:])
        print(completed.stderr[-2000:])
        raise SystemExit(f"{label} failed")

    with open(report_path, encoding="utf-8") as handle:
        report = json.load(handle)
    report["_wall_s"] = round(wall, 2)
    report["_label"] = label
    report["_strategy"] = strategy
    report["_scale"] = scale
    print(
        f"    load {report['totals']['load_s']:.2f}s, "
        f"{report['totals']['roundtrips_db']} round trips, "
        f"{report['totals']['bytes_sent_db']:,} bytes",
        flush=True,
    )
    return report


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--small", type=float, default=0.01,
                        help="Reduced scale at which rowwise is tolerable")
    parser.add_argument("--out", default=os.path.join(
        REPO_ROOT, "runs", "headline", "load-benchmark.json"))
    args = parser.parse_args()

    results = []

    print("PHASE 1: all three strategies at reduced scale (fair comparison)")
    for strategy in ("rowwise", "execute_values", "copy"):
        results.append(
            run_once(strategy, args.small, f"small_{strategy}")
        )

    print("PHASE 2: batched strategies at full scale")
    for strategy in ("execute_values", "copy"):
        results.append(run_once(strategy, 1.0, f"full_{strategy}"))

    rtt = next(
        (r["environment"].get("db_rtt_ms") for r in results
         if r["environment"].get("db_rtt_ms")), None
    )

    # Extrapolate the full-scale row-at-a-time cost from its measured
    # per-round-trip cost at reduced scale.
    small_rowwise = results[0]
    measured_trips = small_rowwise["totals"]["roundtrips_db"]
    measured_load = small_rowwise["totals"]["load_s"]
    per_trip = measured_load / measured_trips if measured_trips else None
    extrapolated = {
        "basis": {
            "scale": args.small,
            "measured_roundtrips": measured_trips,
            "measured_load_s": round(measured_load, 2),
            "measured_s_per_roundtrip": round(per_trip, 4) if per_trip else None,
            "db_rtt_ms": rtt,
        },
        "full_scale_pg_rows": FULL_SCALE_PG_ROWS,
        "projected_roundtrips": FULL_SCALE_PG_ROWS,
        "projected_load_s": round(per_trip * FULL_SCALE_PG_ROWS, 1) if per_trip else None,
        "projected_load_hours": round(
            per_trip * FULL_SCALE_PG_ROWS / 3600, 2) if per_trip else None,
        "note": ("Row-at-a-time issues one round trip per row. Measured at "
                 "reduced scale and projected, because a full-scale run would "
                 "take hours. Labelled as projected, never as measured."),
    }

    payload = {
        "benchmark": "PostgreSQL load strategies",
        "method": ("Each configuration is a full pipeline invocation in its own "
                   "subprocess, run strictly sequentially with nothing else "
                   "executing. Round trips are counted by an instrumented "
                   "cursor, not estimated. Byte counts are exact for COPY."),
        "database": "Supabase PostgreSQL 17.11, eu-west-1",
        "db_rtt_ms": rtt,
        "runs": [
            {
                "label": r["_label"],
                "strategy": r["_strategy"],
                "scale": r["_scale"],
                "rows_loaded": r["totals"]["rows_loaded"],
                "load_s": round(r["totals"]["load_s"], 3),
                "roundtrips": r["totals"]["roundtrips_db"],
                "bytes_sent": r["totals"]["bytes_sent_db"],
                "load_rows_per_s": r["totals"].get("load_rows_per_s"),
                "generate_s": round(r["totals"]["generate_s"], 2),
                "wall_s": r["_wall_s"],
                "per_table": {
                    t["table"]: {
                        "rows": t["rows"],
                        "load_s": (t.get("load") or {}).get("duration_s"),
                        "roundtrips": (t.get("load") or {}).get("roundtrips"),
                        "bytes_sent": (t.get("load") or {}).get("bytes_sent"),
                    }
                    for t in r["tables"] if t.get("load")
                },
            }
            for r in results
        ],
        "rowwise_full_scale_projection": extrapolated,
    }

    with open(args.out, "w", encoding="utf-8") as handle:
        json.dump(payload, handle, indent=2)

    # -- summary -----------------------------------------------------------
    print()
    print("=" * 78)
    print(f"LOAD STRATEGY COMPARISON   (database round-trip time: {rtt} ms)")
    print("=" * 78)
    print(f"{'configuration':<28}{'rows':>8}{'trips':>8}{'load s':>9}"
          f"{'rows/s':>10}{'MB':>8}")
    for entry in payload["runs"]:
        mb = entry["bytes_sent"] / (1024 * 1024)
        print(f"{entry['label']:<28}{entry['rows_loaded']:>8,}"
              f"{entry['roundtrips']:>8,}{entry['load_s']:>9.2f}"
              f"{(entry['load_rows_per_s'] or 0):>10,.0f}{mb:>8.1f}")

    small = {r["strategy"]: r for r in payload["runs"] if r["scale"] == args.small}
    if "rowwise" in small:
        base = small["rowwise"]["load_s"]
        print()
        print(f"At scale {args.small}, relative to row-at-a-time:")
        for strategy in ("execute_values", "copy"):
            if strategy in small:
                print(f"  {strategy:<16} {base / small[strategy]['load_s']:>7.1f}x faster")

    proj = payload["rowwise_full_scale_projection"]
    if proj["projected_load_s"]:
        print()
        print("Full-scale row-at-a-time, PROJECTED (not measured):")
        print(f"  {proj['projected_roundtrips']:,} round trips at "
              f"{proj['basis']['measured_s_per_roundtrip']}s each")
        print(f"  = {proj['projected_load_s']:,.0f}s "
              f"({proj['projected_load_hours']} hours)")
        full = {r["strategy"]: r for r in payload["runs"] if r["scale"] == 1.0}
        for strategy in ("execute_values", "copy"):
            if strategy in full:
                speedup = proj["projected_load_s"] / full[strategy]["load_s"]
                print(f"  vs measured {strategy}: {full[strategy]['load_s']:.1f}s "
                      f"-> {speedup:,.0f}x")
    print()
    print(f"wrote {args.out}")


if __name__ == "__main__":
    main()
