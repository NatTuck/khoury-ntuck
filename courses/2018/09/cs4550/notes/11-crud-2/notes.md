---
layout: default
---

## First: Homework Questions

## Continuing the HuskyShop App

 * Code available at: https://github.com/NatTuck/husky_shop
 * Today starts at: 1-bootstrap
 * Prep for deploy: 2-deploy
 * ...

## Prepare for Deployment

We want to be able to deploy our app, and there are a couple of things we
need to do to make that happen.

Here's the deployment guides, which are worth reading to see where these steps
came from.

 - https://github.com/phoenixframework/phoenix/blob/master/guides/deployment/deployment.md
 - https://hexdocs.pm/distillery/guides/phoenix_walkthrough.html

Keep in mind that the distillery guide is for Phoenix 1.3 and there may be minor
version differences.

We'll use the Distillery library to build our release.

First thing: Add distillery lib to mix.exs and install it:

```
...
  defp deps do
    [
    ...
      {:distillery, "~> 2.0"},
```

```
$ mix deps.get
$ mix release.init
```

### Problem 1: Production Secrets

A secret is a piece of information that would result in security problems
if it were to be published. Examples include passwords, cryptographic keys,
and API keys. 

Secrets should never be committed to a version control like git. This is
especially true for public github repositories like we use in this class.

Our app has three secrets:

 - secret\_key\_base - An attacker learning this secret could generate fake
   Phoenix tokens, including session cookies.
 - Database password - This could allow an attacker to directly connect to
   the database and issue SQL commands.
 - Erlang security cookie - This could allow an attacker to send erlang
   messages, which allows running arbitrary code.

Phoenix provides a mechanism to solve this problem by default:

 - Store secrets in config/prod.secret.exs
 - Don't commit that file to source control.
 - Manually copy that file to the server during deployment.

That works, but is annoying. I'm a fan of an alternate system:

 - Store secrets on the server outside your application directory,
   e.g. in ~/.config/husky_shop
 - If secrets are missing, generate new ones.

Let's set up Husky Shop to work that way.

Move the contents of config/prod.secret.exs into config/prod.exs:
 
```
$ cat config/prod.secret.exs >> config/prod.exs
$ rm config/prod.secret.exs
```

Edit config/prod.exs:

 * Delete the import line for prod.secret.exs

```
...
get_secret = fn name ->
  base = Path.expand("~/.config/husky_shop")
  File.mkdir_p!(base)
  path = Path.join(base, name)
  unless File.exists?(path) do
    secret = Base.encode16(:crypto.strong_rand_bytes(32))
    File.write!(path, secret)
  end
  String.trim(File.read!(path))
end

config :husky_shop, HuskyShopWeb.Endpoint,
  secret_key_base: get_secret.("key_base");

# Configure your database
config :husky_shop, HuskyShop.Repo,
  username: "husky_shop",
  password: get_secret.("db_pass"),
  database: "husky_shop_prod",
  pool_size: 15
```

The other secret is in rel/config.exs, let's add get_secret there too.

```
...
 # Add get_secret def from above
...

environment :dev do
  ... 
  # Dev secrets are less important, but we're here already.
  set cookie: String.to_atom(get_secret.("dev_cookie"))
end

environment :prod do
  ... 
  set cookie: String.to_atom(get_secret.("prod_cookie"))
end
```

### Problem 2: Config Tweaks

By default, Phoenix apps aren't configured to actually serve web pages in
production mode, and there's some other minor issues. Let's fix that.

In config, prod.exs, we want to edit the top config block:

```
...
config :husky_shop, HuskyShopWeb.Endpoint,
  server: true,
  root: ".",
  version: Application.spec(:phoenix_distillery, :vsn),
  http: [:inet6, port: {:system, "PORT"}],
  url: [host: "shop.ironbeard.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"
```


## Minimum Deployment

Log in to server.

Create a new user:

```
# pwgen 12 1
<password>
# adduser husky_shop
password: <password>
again: <password>
   Name: Husky Shop
...
# sudo su - husky_shop
```

Clone git repo:

```
$ git clone https://github.com:NatTuck/husky_shop.git
$ cd husky_shop
```

Get dependencies:

```
$ mix deps.get
$ (cd assets && npm install)
```

Create the DB:

```
$ mkdir -p ~/.config/husky_shop
$ pwgen 12 1 > ~/.config/husky_shop/db_pass
$ cat ~/.config/husky_shop/db_pass
<password>
root# su - postgres
pg$ createuser -d husky_shop
pg$ psql
postgres=# alter user husky_shop with password '<password>';
pg$ ^D
$ export MIX_ENV=prod
$ mix ecto.create
$ mix ecto.migrate
```

Set up nginx

/etc/nginx/sites-available/shop.ironbeard.com

```
server {
    listen 80;
    listen [::]:80;

    server_name shop.ironbeard.com;

    location / {
        proxy_pass http://localhost:4747;
    }

    location /socket {
        proxy_pass http://localhost:4747;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";	 	 
    }
}
```

```
# ln -s /etc/nginx/sites-available/shop.ironbeard.com /etc/nginx/sites-enabled
# service nginx restart
```

Build a release:

```
$ cd assets 
$ export MIX_ENV=prod
$ export PORT=4747
$ npm install
$ node_modules/.bin/webpack --mode production
$ cd ..
$ mix phx.digest
$ mix compile
$ mix release --env=prod
```

Test out the release.

 * Run the foreground command.
 * Visit http://shop.ironbeard.com/

TODO: More steps.



