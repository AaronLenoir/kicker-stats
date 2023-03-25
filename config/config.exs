# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :web_api_web,
  generators: [context_app: :web_api]

# Configures the endpoint
config :web_api_web, WebApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: WebApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: WebApi.PubSub,
  live_view: [signing_salt: "cp2VOUxy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :http_stream, adapter: HTTPStream.Adapter.HTTPoison

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
