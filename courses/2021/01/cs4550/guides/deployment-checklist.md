+++
title = "Deployment Checklist"
+++

# Elixir / Phoenix app deployment checklist:

System users:

 - You should create a new user for your app.
 - Run most deployment commands as that user (sudo su - username)
 - Only run commands as root when editing system config files (i.e. under /etc),
   controlling system services (e.g. "service" command), or installing system
   packages (with apt).

Server setup:

 - Set server timezone: ```sudo dpkg-reconfigure tzdata```

Before deployment:

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
 - Test the release by running your start script so you can see
   log output.
 - The release can then be run either in place or by copying the
   release file to another identical machine.

Setting up a systemd service:

 - Make sure you have a working start script using the start command
   output by the "mix release" command.
 - Create a service file (see template in memory repo)
 - Copy it to /etc/systemd/system/yourapp.service
 - Enable it with: systemctl enable yourapp.service
 - Start it with: service yourapp start

TLS setup with certbot:

 - sudo apt install certbot python3-certbot-nginx
 - sudo certbot

# The Actual Documentation

Elixir/Phoenix Deployment:

 - https://hexdocs.pm/phoenix/deployment.html
 - https://hexdocs.pm/phoenix/releases.html


