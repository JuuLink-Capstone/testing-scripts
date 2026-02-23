#!/bin/bash
# Usage: run_locust.sh [RUN_TIME]
set -e  # Exit immediately if a command fails

# ====== CONFIG ======
VENV_DIR="locust-env"
REQUIREMENTS_FILE="requirements.txt"
LOCUSTFILE="locustfile.py"
HOST="http://192.168.100.2"
USERS=50
SPAWN_RATE=5
RUN_TIME="3m"
CSV_PREFIX="results"

if [ $1 ]; then
  RUN_TIME="$1"
fi

# ====== SETUP VENV ======

# Create venv if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
fi

# Activate venv
source "$VENV_DIR/bin/activate"

# Upgrade pip (optional but recommended)
pip install --upgrade pip

# Install dependencies
if [ -f "$REQUIREMENTS_FILE" ]; then
  echo "Installing requirements..."
  pip install -r "$REQUIREMENTS_FILE"
else
  echo "WARNING: requirements.txt not found"
fi

# ====== RUN LOCUST ======

locust \
  -f "$LOCUSTFILE" \
  --host "$HOST" \
  --users "$USERS" \
  --spawn-rate "$SPAWN_RATE" \
  --run-time "$RUN_TIME" \
  --headless \
  --csv "$CSV_PREFIX"