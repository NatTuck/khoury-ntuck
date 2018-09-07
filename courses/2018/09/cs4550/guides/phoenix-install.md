---
layout: default
---

[<= Go Back](../)

# Setup: Phoenix Framework

## Installing the Software

To get set up for web app development and deployment, you want to get the
following software packages installed on both your development machine and your
deployment machine (VPS).

 - Erlang / OTP version 21
 - Elixir version 1.7
 - Phoenix version 1.4
 - NodeJS version 8.10 (e.g. the Ubuntu packages: nodejs npm)
 - Standard C/C++ dev tools (e.g. the Ubuntu build-essential package)

Here's the relevent installation instructions / resources. You will need to read
these instructions and follow the directions:

 - [Elixir Install](https://elixir-lang.org/install.html)
 - [Phoenix Install](https://hexdocs.pm/phoenix/installation.html)

For Ubuntu 18.04, up to date versions Erlang and Elixir are available as
packages in a third party repository from Erlang Solutions. The versions of
these packages in the stock Ubuntu repository are too old - don't install those
versions.

You should also install PostgreSQL. This can be installed normally from the
Ubuntu repositories, packages are: postgresql postgresql-client libpq-dev

