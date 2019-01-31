



### Setup for Deployment

 - Add elixir module: distillery.
 - Follow deploy guide to create a deploy script.
 - Worry about secrets.
   - config/prod.secret.exs - Copy manually from dev machine.
   - rel/config.exs - Random cookie code; will break if we try
         to run in a cluster.
 - There should *never* be secrets in your git repo.

