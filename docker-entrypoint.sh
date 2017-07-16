#!/usr/bin/env bash
set -e

if [[ "${ENV}" == "test" || "${ENV}" == "dev" ]]; then
  echo "executing docker-entrypoint.sh..."
  dep ensure -v
  ./bin/db_migrations
fi

exec "$@"
