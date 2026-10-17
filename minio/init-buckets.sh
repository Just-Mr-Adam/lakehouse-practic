#!/bin/bash
set -e

# Ждём, пока MinIO поднимется
until curl -s http://localhost:9000/minio/health/live; do
  echo "Waiting for MinIO..."
  sleep 2
done

# Настраиваем alias для mc
docker run --rm --network host --entrypoint sh minio/mc -c "
  mc alias set local http://localhost:9000 minioadmin minioadmin &&
  mc mb -p local/warehouse || true &&
  mc mb -p local/bronze || true
"

echo "Buckets 'warehouse' and 'bronze' are ready."