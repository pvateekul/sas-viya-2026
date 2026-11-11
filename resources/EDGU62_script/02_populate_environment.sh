cat > ~/02_populate_environment.sh <<'BASH'
#!/usr/bin/env bash
set -eo pipefail

REPO_DIR="$HOME/dgu"
SETUP_DIR="$REPO_DIR/scripts/loop/viya4"

if [ ! -d "$SETUP_DIR" ]; then
  echo "ERROR: $SETUP_DIR was not found." >&2
  echo "Run 01_clone_repo.sh first." >&2
  exit 1
fi

cd "$SETUP_DIR"

scripts=(
  GEL.0850.sampgel.caslib.2025.09.sh
  GEL.0852.public.caslib.2025.09.sh
  GEL.0854.compgel.lib.2025.09.sh
  GEL.0856.listings.caslib.2025.09.sh
  GEL.0858.caspgdvd.caslib.2025.09.sh
  GEL.0859.set.feature.flags.2025.09.sh
  GEL.0860.catalog.api.bots.2025.09.sh
  GEL.0868.import.assets.2025.09.sh
  GEL.0870.catalog.api.glossary.2025.09.sh
)

# Check every script before starting.
for script in "${scripts[@]}"; do
  if [ ! -f "$script" ]; then
    echo "ERROR: Missing script: $SETUP_DIR/$script" >&2
    exit 1
  fi
done

# Keep a separate log for each run.
LOG_FILE="$SETUP_DIR/GEL.setup.$(date +%Y%m%d_%H%M%S).$$.log"

echo "Setup started: $(date)" | tee -a "$LOG_FILE"
echo "Log: $LOG_FILE" | tee -a "$LOG_FILE"

for script in "${scripts[@]}"; do
  echo "Running: $script" | tee -a "$LOG_FILE"

  if bash "$script" 2>&1 | tee -a "$LOG_FILE"; then
    echo "Finished: $script" | tee -a "$LOG_FILE"
  else
    echo "FAILED: $script" >&2
    echo "Check log: $LOG_FILE" >&2
    exit 1
  fi
done

echo "All setup scripts finished: $(date)" | tee -a "$LOG_FILE"

echo "Checking log lines containing 'error'..."
if grep -in "error" "$LOG_FILE"; then
  echo "Review these lines; some may indicate zero errors."
else
  echo "No lines containing 'error' found."
fi

echo "Log saved to: $LOG_FILE"
BASH