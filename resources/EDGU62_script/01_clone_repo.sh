cat > ~/01_clone_repo.sh <<'BASH'
#!/usr/bin/env bash
set -eo pipefail

export MYREPO=dgu
export MYBRANCH=main

# Uncomment if your workshop requires this branch:
# export MYBRANCH=2026.09

REPO_DIR="$HOME/$MYREPO"
REPO_URL="https://gelgitlab.race.sas.com/GEL/edu/dm1/${MYREPO}.git"

if [ ! -d "$REPO_DIR" ]; then
  echo "Cloning $MYREPO, branch $MYBRANCH..."
  git clone \
    --branch "$MYBRANCH" \
    --single-branch \
    --depth 1 \
    "$REPO_URL" "$REPO_DIR"
elif [ ! -d "$REPO_DIR/.git" ]; then
  echo "ERROR: $REPO_DIR exists but is not a Git repository." >&2
  exit 1
else
  echo "Repository already exists. Keeping its current contents and branch."
fi

cd "$REPO_DIR"

echo "Repository: $PWD"
echo "Current branch:"
git branch --show-current

echo "Available branches:"
git branch -a

echo "Repository contents:"
ls -la

if [ ! -d scripts/loop/viya4 ]; then
  echo "ERROR: scripts/loop/viya4 was not found." >&2
  exit 1
fi

echo "Repository is ready."
BASH