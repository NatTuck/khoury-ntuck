
# Elixir / Phoenix app deployment checklist:

System users:

 - You should create a new user for your app.
 - Run most deployment commands as that user (sudo su - username)
 - Only run commands as root when editing system config files (i.e. under /etc),
   controling system services (e.g. "service" command), or installing system
   packages (with apt).

Before deployment:

 - Add the "distillery" package to your application and create the release
   config file.
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
 - Test the release by running it in the foreground so you can see
   log output.
 - The release can then be run either in place or by copying the
   release file to another identical machine.

# The Actual Documentation

Elixir/Phoenix Deployment:

 - https://hexdocs.pm/phoenix/deployment.html
 - https://hexdocs.pm/distillery/guides/phoenix_walkthrough.html


