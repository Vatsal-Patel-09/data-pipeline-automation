#!/usr/bin/env bash
# ===================================================================
#  SynthForge - one entry point for everything (macOS / Linux).
#
#    ./run.sh              preflight, pipeline at 5%, API, website
#    ./run.sh full         the same, at full scale (100,400 records)
#    ./run.sh site         website only
#    ./run.sh api          API server only
#    ./run.sh pipeline [s] pipeline only, optional scale (default 0.05)
#    ./run.sh offline      everything with no database at all
#    ./run.sh test         the test suite
#    ./run.sh clean        drop the model's tables from the database
#    ./run.sh check        preflight only: python, deps, .env, database
#    ./run.sh install      install dependencies
#    ./run.sh help         this message
#
#  First time on macOS:  chmod +x run.sh
# ===================================================================

set -u

cd "$(dirname "$0")" || exit 1

# Prefer a local virtualenv, then python3 (macOS has no bare `python`),
# then python. Override with PYTHON=/path/to/python if needed.
if [ -n "${PYTHON:-}" ]; then
  PY="$PYTHON"
elif [ -x ".venv/bin/python" ]; then
  PY=".venv/bin/python"
elif command -v python3 >/dev/null 2>&1; then
  PY="python3"
else
  PY="python"
fi

ACTION="${1:-demo}"

usage() {
  cat <<'EOF'

  SynthForge
  ----------------------------------------------------------------
  ./run.sh                preflight, pipeline at 5%, API, website
  ./run.sh full           the same, at full scale (100,400 records)
  ./run.sh site           website only
  ./run.sh api            API server only
  ./run.sh pipeline [s]   pipeline only, optional scale (default 0.05)
  ./run.sh offline        everything with no database at all
  ./run.sh test           the test suite
  ./run.sh clean          drop the model's tables from the database
  ./run.sh check          preflight only
  ./run.sh install        install dependencies

  Only pipeline and api need a database. site, offline and the
  default test run work without one.
EOF
}

need_python() {
  if ! "$PY" --version >/dev/null 2>&1; then
    echo "[X] Python was not found on PATH."
    echo "    Install Python 3.11+ (brew install python) and reopen this terminal."
    return 1
  fi
  if ! "$PY" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)' >/dev/null 2>&1; then
    echo "[X] $("$PY" --version 2>&1) is too old. Python 3.11+ is required."
    return 1
  fi
}

check() {
  need_python || return 1
  echo
  echo "  Preflight"
  echo "  ----------------------------------------------------------------"
  echo "  [ok] $("$PY" --version 2>&1)"

  if ! "$PY" -c "import psycopg2,faker,fastapi,uvicorn,dotenv,pandas,pyarrow,click" >/dev/null 2>&1; then
    echo "  [X] Some dependencies are missing. Run: ./run.sh install"
    return 1
  fi
  echo "  [ok] Dependencies importable"

  if [ ! -f ".env" ]; then
    echo "  [!] .env not found. Copy example.env to .env and fill it in."
    echo "      Without it only 'site', 'offline' and 'test' will work."
  else
    echo "  [ok] .env present"
  fi

  echo "  [..] Checking the model contract"
  if ! "$PY" data_pipeline.py validate --model ecommerce_model.json >/dev/null 2>&1; then
    echo "  [X] Model failed validation. Run: $PY data_pipeline.py validate"
    return 1
  fi
  echo "  [ok] Model is valid"

  if [ -f ".env" ]; then
    echo "  [..] Reaching the database (this can take a few seconds)"
    if "$PY" -c "import sys;sys.path.insert(0,'.');from dotenv import load_dotenv;load_dotenv('.env');from src.db import connect;c=connect();c.close();print('   [ok] Database reachable')" 2>/dev/null; then
      :
    else
      echo "  [!] Database not reachable. 'offline' and 'site' still work."
    fi
  fi
  echo
}

API_PID=""
SITE_PID=""

stop_servers() {
  if [ -n "$API_PID" ]; then kill "$API_PID" 2>/dev/null || true; fi
  if [ -n "$SITE_PID" ]; then kill "$SITE_PID" 2>/dev/null || true; fi
}

start_servers() {
  "$PY" api_server.py "$@" --port 8000 &
  API_PID=$!
  sleep 3
  "$PY" serve_demo.py --port 8900 &
  SITE_PID=$!

  echo "  API     : http://127.0.0.1:8000/docs"
  echo "  Website : http://127.0.0.1:8900/"
  echo
  echo "  Press Ctrl+C to stop both servers."
  echo

  trap 'stop_servers; exit 0' INT TERM
  trap 'stop_servers' EXIT
  wait
}

case "$ACTION" in
  help|-h|--help)
    usage
    exit 0
    ;;
  install)
    need_python || exit 1
    echo "Installing dependencies..."
    if ! "$PY" -m pip install -r requirements.txt; then
      echo "[X] pip install failed."
      echo "    On Homebrew Python this usually means an externally managed"
      echo "    environment. Create and use a virtualenv:"
      echo "      python3 -m venv .venv && source .venv/bin/activate"
      exit 1
    fi
    echo "[ok] Dependencies installed."
    ;;
  check)
    check
    exit $?
    ;;
  clean)
    need_python || exit 1
    echo
    echo "  Dropping the tables this model declares. Nothing else is touched."
    echo
    "$PY" data_pipeline.py clean-db --model ecommerce_model.json --env .env
    exit $?
    ;;
  test)
    need_python || exit 1
    echo
    echo "  Running the test suite. Database-marked tests skip without a database."
    echo
    "$PY" -m pytest -q
    exit $?
    ;;
  pipeline)
    need_python || exit 1
    SCALE="${2:-0.05}"
    echo
    echo "  Running the pipeline at scale $SCALE"
    echo
    "$PY" data_pipeline.py run --scale "$SCALE" --load-all --verify-writes
    exit $?
    ;;
  offline)
    need_python || exit 1
    echo
    echo "  Offline: generating and writing every file sink, no network."
    echo
    if ! "$PY" data_pipeline.py --offline --scale 0.05; then
      echo "[X] Offline run failed."
      exit 1
    fi
    echo
    echo "  Starting the API server from the generated file, then the website."
    start_servers --offline
    ;;
  site)
    need_python || exit 1
    echo
    echo "  Starting the website. The Live run page can trigger the real pipeline."
    echo
    exec "$PY" serve_demo.py --port 8900
    ;;
  api)
    need_python || exit 1
    echo
    echo "  Starting the API server on port 8000. Docs at /docs"
    echo
    exec "$PY" api_server.py --port 8000
    ;;
  demo|full)
    need_python || exit 1
    check || exit 1

    SCALE="0.05"
    if [ "$ACTION" = "full" ]; then SCALE="1.0"; fi

    echo "  Pipeline"
    echo "  ----------------------------------------------------------------"
    echo "  Scale $SCALE, every declared table loaded, writes verified."
    echo
    if ! "$PY" data_pipeline.py run --scale "$SCALE" --load-all --verify-writes; then
      echo
      echo "  [X] The pipeline failed. See runs/run_report.json for the traceback."
      echo "      The website still runs: try  ./run.sh site"
      exit 1
    fi

    echo
    echo "  Servers"
    echo "  ----------------------------------------------------------------"
    start_servers
    ;;
  *)
    echo "Unknown action: $ACTION"
    echo
    usage
    exit 1
    ;;
esac
