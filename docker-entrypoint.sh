#!/usr/bin/env bash
set -e

# Update deps every time the container is run in test or dev mode
if [[ "${ENV}" == "test" || "${ENV}" == "dev" ]]; then
  echo "executing docker-entrypoint.sh..."
  dep ensure
fi

# Re-compile and run db-migrations every time the container is in dev mode
if [[ "${ENV}" == "dev" ]]; then
  echo "executing docker-entrypoint.sh..."
  ./bin/install
  ./bin/db_migrations
fi

echo "finished executing docker-entrypoint.sh"

exec "$@"
