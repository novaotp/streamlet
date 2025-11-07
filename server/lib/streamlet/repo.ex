defmodule Streamlet.Repo do
  use Ecto.Repo,
    otp_app: :streamlet,
    adapter: Ecto.Adapters.Postgres
end
