---
layout: default
---

# Introducing Phoenix

 - A web framework for Elixir
 - Design elements inspired by Ruby on Rails

# Create a Phoenix App

Create app:

```
mix phx.new nu_mart
```

Setup DB

```
$ sudo su - postgres
$ pwgen 10 1
[some password]
$ createuser -d -P nu_mart
Enter password: [some password]
Again: [some password]
$ exit # stop being the postgres user
```

Edit dev config (config/dev.exs)

```
config :microblog, Microblog.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "nu_mart",
  password: "[some password]",
  database: "nu_mart_dev",
  hostname: "localhost",
  pool_size: 10
```

Create db

```
$ mix ecto.create
```

Start the server.

```
# Kill the server, restart
$ mix phx.server
```

Check out http://localhost:4000/

Create Products resource

```
$ mix phx.gen.html Shop Product products name:string price:decimal desc:text
```

Add the suggested line to the router

We need a library for decimal numbers.

```
# Add to mix.exs: {:decimal, "~> 1.0"}
$ mix deps.get
```

Decimal requires settings in the DB schema.

```
$ vim priv/repo/migrations/*_create_products.exs
#     two digits after decimal place:
#     add :price, :decimal, precision: 12, scale: 2
```

Add the new table:

```
$ mix ecto.migrate
```

Try out the app

```
# Kill the server, restart
$ mix phx.server
```

Check out http://localhost:4000/products

## Production Config

Edit the production config (config/prod.exs):

```
config :nu_mart, NuMartWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "eagle.ferrus.net", port: 8000],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"
```

## Commit to Git

Handling config/prod.secret.exs:

 - This contains the app's secrets.
   - Database password.
   - Cookie secret.
 - These are nesisary to run the app, but should
   not be commited to a git repo.
 - So we need a secret management scheme.
 
## Deploying

Create a user, db user, and db on the production server:

```
$ pwgen 12 1
[password 2]
$ ssh user@production
$ sudo su - root
# adduser numart
password: [password 2]
# sudo su - postgres
$ createuser -d -P nu_mart
password: [password 2]
```

Set up SSH login for new user.

```ssh-copy-id numart@host


Cheater deployment:

 - Install esl-erlang / elixir on production server.
 - Check out the git repo as the new user.
 - Fill in config/prod.secret.exs
 - mix deps.get
 - MIX_ENV=prod mix phoenix.digest
 - In screen, MIX_ENV=prod PORT=8000 iex -S mix

## Proper Deployment

Do the deployment:

```
# Add to mix.exs: {:distillery, "~> 1.4"}
$ mix deps.get
$ mix release.init
$ MIX_ENV=prod mix release --env=prod
$ scp _build/prod/rel/nu_mart/releases/0.0.1/nu_mart.tar.gz numar@production
$ ssh numart@production
$ mkdir nu_mart
$ tar xzvf ../nu_mart.tar.gz
$ PORT=8000 ./bin/dorp start
```

## SystemD

See my_app.service

The service file goes in /etc/systemd/system

