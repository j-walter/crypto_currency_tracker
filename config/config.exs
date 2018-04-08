# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :crypto_currency_tracker,
  ecto_repos: [CryptoCurrencyTracker.Repo]

# Configures the endpoint
config :crypto_currency_tracker, CryptoCurrencyTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PdbdwP1yl8HL3k7+rdI1A/c6cZaGM9kWdA/accAsTTJTwXGs5ZlbO8Lqbckg88Kj",
  render_errors: [view: CryptoCurrencyTrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CryptoCurrencyTracker.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

import_config "gauth.secret.exs"