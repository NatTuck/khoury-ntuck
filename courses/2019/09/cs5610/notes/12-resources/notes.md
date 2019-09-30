---
layout: default
---

### Setup for Deployment

 - FIXME: Double-check built-in releases.
 - Add elixir module: distillery.
   - in mix.exs: {:distillery, "~> 2.0"}
   - mix release.init
 - Follow deploy guide to create a deploy script.
 - Worry about secrets.
   - config/prod.secret.exs - Copy manually from dev machine.
   - rel/config.exs - Random cookie code; will break if we try
         to run in a cluster.
 - There should *never* be secrets in your git repo.

### Generate Secrets at Deploy Time

This snippet of code is useful for managing secrets in config/prod.exs and
rel/config.exs

Feel free to use this in your projects with the attribution comment. This
assumes that your build machine and your production server are the same. That
may not be a good idea for larger deployments and stops working once you have
two web servers.

```
get_secret = fn name ->
  # Secret generation hack by Nat Tuck for CS4550
  # This function is dedicated to the public domain.
  base = Path.expand("~/.config/phx-secrets")
  File.mkdir_p!(base)
  path = Path.join(base, name)
  unless File.exists?(path) do
    secret = Base.encode16(:crypto.strong_rand_bytes(32))
    File.write!(path, secret)
  end
  String.trim(File.read!(path))
end

## In config/prod.exs
secret_key_base: get_secret.("key_base");
...
password: get_secret.("db_pass") # Manually make file match password

## In rel/config.exs
set cookie: String.to_atom(get_secret.("dev_cookie"))
```
