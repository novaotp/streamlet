#!/bin/bash

set -e

mix deps.get

mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs

mix phx.server
