---
layout: default
---

[<= Go Back](../)

# Setup: Phoenix Framework

## Installing the Software

To get set up for web app development and deployment, you want to get the
following software packages installed on both your development machine and your
deployment machine (VPS).

 - Erlang / OTP version 20.2
 - Elixir version 1.5
 - Phoenix version 1.3
 - NodeJS version 9.4
 - Standard C/C++ dev tools (e.g. the Ubuntu build-essential package)

Here's the relevent installation instructions / resources. You will need to read
these instructions and follow the directions:

 - [Elixir Install](https://elixir-lang.org/install.html)
 - [Phoenix Install](https://hexdocs.pm/phoenix/installation.html)
 - [NodeJS Install](https://github.com/nodesource/distributions)

For Ubuntu 16.04, up to date versions Erlang, Elixir, and NodeJS are available
as packages in third party repositories. For Erlang / Elixir this is from Erlang
Solutions.  For NodeJS this is from NodeSource. The versions of these packages
in the stock Ubuntu repository are too old - don't install those versions.

You should also install PostgreSQL. This can be installed normally from the
Ubuntu repositories, packages are: postgresql postgresql-client libpq-dev

