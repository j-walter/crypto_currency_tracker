#!/bin/bash

export PORT=5103
export MIX_ENV=prod

INITIAL_DIR=`pwd`


if [ ! $(id -u) = 0 ]; then
  exit 1
fi

POSTGRES_PASSWORD=$(openssl rand -base64 32)
SECRET_KEY_BASE=$(openssl rand -base64 64)

echo "
use Mix.Config
config :crypto_currency_tracker, CryptoCurrencyTracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: \"crypto_currency_tracker\",
  password: \"$POSTGRES_PASSWORD\",
  database: \"crypto_currency_tracker\",
  hostname: \"localhost\",
  pool_size: 10
config :crypto_currency_tracker, CryptoCurrencyTracker.Endpoint,
    secret_key_base: \"$SECRET_KEY_BASE\"
" > $INITIAL_DIR/config/prod.secret.exs

chown crypto_currency_tracker:crypto_currency_tracker "$INITIAL_DIR/config/prod.secret.exs"
chown crypto_currency_tracker:crypto_currency_tracker "/home/crypto_currency_tracker/" -R

su postgres -c "psql -c \"CREATE USER crypto_currency_tracker;\""
su postgres -c "psql -c \"ALTER USER crypto_currency_tracker WITH PASSWORD '${POSTGRES_PASSWORD}';\""
su postgres -c "psql -c \"CREATE DATABASE crypto_currency_tracker;\""
su postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE crypto_currency_tracker to crypto_currency_tracker;\""

su crypto_currency_tracker -c "
cd "$INITIAL_DIR"
mix deps.get
(cd assets && npm install)
(cd assets && npm rebuild node-sass)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
MIX_ENV=prod mix ecto.create
MIX_ENV=prod mix ecto.migrate
source ~/.profile
ERLANG_COOKIE=\"$(openssl rand -base64 64)\" REPLACE_OS_VARS=true MIX_ENV=prod mix release
mkdir -p ~/www
mkdir -p ~/old
NOW=\$(date +%s)
if [ -d ~/www/crypto_currency_tracker ]; then
	echo mv ~/www/crypto_currency_tracker ~/old/\$NOW
	mv ~/www/crypto_currency_tracker ~/old/\$NOW
fi
mkdir -p ~/www/crypto_currency_tracker
REL_TAR=\"$INITIAL_DIR/_build/prod/rel/crypto_currency_tracker/releases/0.0.1/crypto_currency_tracker.tar.gz\"
echo \"Extracting \$REL_TAR to ~/www/crypto_currency_tracker\"
(cd ~/www/crypto_currency_tracker && tar xzf \$REL_TAR)
crontab - <<CRONTAB
@reboot bash $INITIAL_DIR/start.sh
CRONTAB
"