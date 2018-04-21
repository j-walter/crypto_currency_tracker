use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside

config :crypto_currency_tracker, CryptoCurrencyTrackerWeb.Endpoint,
server: true,
  load_from_system_env: true,
  http: [ip: {127, 0, 0, 1}, port: 5103],
  cache_static_manifest: "priv/static/cache_manifest.json",
  root: "."

# Do not print debug messages in production
config :logger, level: :info

config :crypto_currency_tracker, CryptoCurrencyTracker.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "email-smtp.us-east-1.amazonaws.com",
  port: 587,
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :always,
  ssl: true,
  retries: 1

import_config "prod.secret.exs"