use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside

config :crypto_currency_tracker, CryptoCurrencyTrackerWeb.Endpoint,
server: true,
  load_from_system_env: true,
  url: [host: "cryptocoin.loopback.onl", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  root: "."

# Do not print debug messages in production
config :logger, level: :info
