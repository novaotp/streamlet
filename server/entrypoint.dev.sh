#!/bin/bash

set -e

# Ensure the app's dependencies are installed
mix deps.get

# Wait until Postgres is ready
# while ! pg_isready -q -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER
# do
#   echo "$(date) - waiting for database to start"
#   sleep 2
# done

mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs

mix phx.server
