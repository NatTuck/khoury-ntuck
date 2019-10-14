
# Elixir / Phoenix app deployment checklist:

System users:

 - You should create a new user for your app.
 - Run most deployment commands as that user (sudo su - username)
 - Only run commands as root when editing system config files (i.e. under /etc),
   controling system services (e.g. "service" command), or installing system
   packages (with apt).

Before deployment:

 - Create your release config.
 - Think about application secrets.
 - Make sure your production config is correct for release.
 - Double check for "server: true".
 
Deployment process:

 - Check out your git repository in your new user's home directory.
 - Make sure MIX_ENV is set correctly.
 - Fetch Elixir deps and compile.
 - Fetch JS deps and webpack.
 - Generate asset digests.
 - Once the above is done, you can create a release.
 - Test the release by running it so you can see log output.
 - The release can then be run either in place or by copying the
   release file to another identical machine.

Setting up a systemd service:

 - Make sure you have a working start script using "foreground"
 - Create a service file (see template in memory repo)
 - Copy it to /etc/systemd/system/yourapp.service
 - Enable it with: systemctl enable yourapp.service
 - Start it with: service yourapp start
 
Setting up nginx reverse proxy:

 - Make sure you have a nginx config for your new site that
   reverse proxies the correct host to the correct port.

# The Actual Documentation

Elixir/Phoenix Deployment:

 - https://hexdocs.pm/phoenix/deployment.html
 - https://hexdocs.pm/distillery/guides/phoenix_walkthrough.html

# A Neat Trick

For single server deploys, it's possible to generate secrets at deploy time.

This snippet of code is useful for managing secrets in config/prod.exs and
rel/config.exs ; it stores secrets as files in ~/.config/phx-secrets .

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



