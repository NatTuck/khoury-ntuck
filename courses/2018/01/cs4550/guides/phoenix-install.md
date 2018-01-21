---
layout: default
---

# Setup: Phoenix Framework

## Installing the Software

To get set up for web app development and deployment, you want to get the
following software packages installed on both your development machine and your
deployment machine (VPS).

 - Erlang / OTP version 20.2
 - Elixir version 1.5
 - Phoenix version 1.3
 - NodeJS version 9.4
 - PostgreSQL 9.5
 - Standard C/C++ dev tools (e.g. the Ubuntu build-essential package)

Here's the relevent installation instructions / resources. You will need to read
these instructions and follow the directions:

 - https://elixir-lang.org/install.html
 - https://hexdocs.pm/phoenix/installation.html
 - https://github.com/creationix/nvm

For Ubuntu 16.04, up to date versions Erlang and Elixir are available as
packages in a third party repository (Erlang Solutions). An up to date version
of NodeJS is not available as an Ubuntu package, and should be installed through
NVM. The versions of these packages available in the default Ubuntu repositories
are too old - don't install them.

PostgreSQL can be installed normally from the Ubuntu repositories.

