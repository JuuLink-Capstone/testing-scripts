#!/bin/bash
# Path to locustfile.py
LOCUSTFILE="locustfile.py"

# Target host (your local IP website)
HOST="http://100.107.5.66"

# Number of users
USERS=50

# Spawn rate (users per second)
SPAWN_RATE=5

# Run time
RUN_TIME="3m"

# Output CSV prefix (files like results_stats.csv, etc.)
CSV_PREFIX="results"

# ====== RUN LOCUST ======

locust \
  -f "$LOCUSTFILE" \
  --host "$HOST" \
  --users "$USERS" \
  --spawn-rate "$SPAWN_RATE" \
  --run-time "$RUN_TIME" \
  --headless \
  --csv "$CSV_PREFIX"