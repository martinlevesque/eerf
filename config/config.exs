# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :eerf,
  ecto_repos: [Eerf.Repo]

# Configures the endpoint
config :eerf, EerfWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PR1wJv0c4CiQCg/2qz2FFoHAfqdPmIcy3C74YBVkxFwAPuzkrw7yvDDxwXJdMwvz",
  render_errors: [view: EerfWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Eerf.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :eerf, Eerf.Auth.Guardian,
  issuer: "eerf", # Name of your app/company/product
  secret_key: "amK2bLBQ0gHFMK9rAZTiXtoE/fKWie1wvF9ECW/PWnqVXbUfrhBX5Aj+v/V58EX7"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
