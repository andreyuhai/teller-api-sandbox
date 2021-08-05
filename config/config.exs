# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :teller_api_sandbox, TellerApiSandboxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eKMe7tuXjX9sd3oligpDO7DbnL+h0n/+uZ7U2/GtNA87yZcWBnwR2p0codeg0qCY",
  render_errors: [view: TellerApiSandboxWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TellerApiSandbox.PubSub,
  live_view: [signing_salt: "MdwqHEXs"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
