#!/bin/bash

export PORT=5103

cd ~/www/crypto_currency_tracker
./bin/crypto_currency_tracker stop || true
./bin/crypto_currency_tracker start