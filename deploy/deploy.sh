#!/usr/bin/env bash
set -euo pipefail

APP_USER="${APP_USER:-$(whoami)}"
APP_DIR="/var/www/${APP_USER}"
LOG_DIR="/var/log/${APP_USER}"
mkdir -p "$LOG_DIR"

cd "$APP_DIR"

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

export APP_NAME="${APP_NAME:-$APP_USER}"
export REPOSITORY_OWNER="${REPOSITORY_OWNER:-shereali}"
export IMAGE_BASE="${IMAGE_BASE:-ghcr.io/${REPOSITORY_OWNER}/edu.kokkhopoth}"
export IMAGE_TAG="${IMAGE_TAG:-latest}"

echo "==> [1/4] Syncing latest repository state (if git initialized)..."
if [ -d .git ]; then
  git fetch origin main || true
  git reset --hard origin/main || true
fi

echo "==> [2/4] Pulling pre-built image (${IMAGE_BASE}/frontend:${IMAGE_TAG}) or building locally..."
if docker compose pull frontend 2>/dev/null; then
  docker compose up -d --remove-orphans
else
  echo "GHCR image pull unavailable, building locally on VPS..."
  docker compose up -d --build --remove-orphans
fi

echo "==> [3/4] Waiting for container health..."
for i in {1..15}; do
  if docker ps --filter "name=${APP_NAME}-frontend-1" --filter "status=running" | grep -q "${APP_NAME}-frontend-1"; then
    echo "Container ${APP_NAME}-frontend-1 is running."
    break
  fi
  sleep 2
done

echo "==> [4/4] Cleaning up dangling Docker images..."
docker image prune -f >/dev/null 2>&1 || true
docker compose ps
echo "✅ Deployment complete for ${APP_NAME}!"

