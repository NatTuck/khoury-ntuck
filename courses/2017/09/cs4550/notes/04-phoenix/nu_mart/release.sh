#!/bin/bash
mix deps.get
(cd assets/node_modules && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
MIX_ENV=prod mix phoenix.digest
MIX_ENV=prod mix release --env=prod

echo "Remember to set up production database on server"
echo "Remember to launch app with PORT set"
