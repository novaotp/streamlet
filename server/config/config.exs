# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :streamlet,
  ecto_repos: [Streamlet.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :streamlet, StreamletWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: StreamletWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Streamlet.PubSub,
  live_view: [signing_salt: "aEmZIBxr"]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_aws,
  region: {:system, "S3_REGION"},
  access_key_id: {:system, "S3_ACCESS_KEY_ID"},
  secret_access_key: {:system, "S3_SECRET_ACCESS_KEY"}

config :ex_aws, :s3,
  scheme: System.get_env("S3_SCHEME"),
  host: System.get_env("S3_HOST"),
  port: String.to_integer(System.get_env("S3_PORT"))

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
