---
layout: default
---

## First Thing

Project questions?

## A Closer Look at OAuth

We're going to look at an OAuth Example app.

https://github.com/NatTuck/oauth2_example

Phoenix 1.2 directory layout:

New layout is better, but we just hit an example where knowing the
old layout is useful - there may be more such examples.

 - ./lib/*_web was ./web
 - there was a ./web/models directory for schemas
 - ./assets was ./web/static/assets
   - package.json and brunch-config.js just lived in the app root

Setting this app up to use the Github API:

 - Github profile photo
 - Settings
 - Developer Settings
 - New OAuth App
 - Fill out the form

This gets us to the app page, where we get two things:

 - Client ID (public)
 - Client Secret (private)

Pull up app source on celedyr, load config/dev.exs

 - Scroll to Github config.
 - It's set up to configure with env variables.
 - This is a common way to handle secrets.
   - In dev, we just stick the values in our ~/.bashrc
   - In production, we can either create a wrapper script
     to launch our app or stick these values directly
     in our systemd service file.
 - In this case, REDIRECT_URI is our callback URL.

Run the app:

 - mix phoenix.server # old version, again
 - load up localhost:4400
 - Log in with github
 - Log out
 - Log in a again
 - Go to Github and deauth (Settings / Applications / OAuth Apps)

Developing locally:

 - You can enter the URL and callback URL as localhost.
 - This will allow you to oauth on the local machine.

Let's take a look at this app

web/router.ex

 - Apparently auth is its own scope.
 - Why is this piped through "browser"?
   - Because these are all browser paths. Doesn't need its own scope.
 - get "/:provider/callback" is the callback URL
   - This is where the provider redirects when authenticating.

web/controllers/auth_controller.ex

 - Index page redirects to external authentication provider.
   - authorize_url! asks the provider module
   - We pass in a "scope" parameter to request access to repos.
 - Delete is the standard log out plan.
   - This just drops the session rather than leaving a cookie with user=nil
 - get_token! does a HTTP post to trade the code for an auth token (see below)
 - get_user! does an API call using the shiny new token (see below)
 - The OAuth2.Client module lets us do authenticated HTTP reqs.

web/oauth/github.ex

 - This should definitely be in ./lib (or ./lib/appname/ in 1.3)
 - Everything's in "config"

web/templates/page/index.html.eex

Two cases:

 - Logged in user, show name and profile photo.
 - Else, show auth buttons for github/facebook/google.

## Issues Demo

Go to /issues

This uses the Github API to access issues.

 - Show issue list.
 - Go to git repo, show that the issues are the same.

Hit "New Issue" button, enter issue.

 - Issue shows up in list.
 - Issue shows up in list on Github.
 - New issue on Github attributed to me - because the app has
   access to act as me via OAuth.

web/models/issue.ex

 - We stuck a "context module" here.
 - It's just backed by the Github API, not the database.
 
 
Let's see if we can implement "delete".

## Other API Complications

Some APIs, like for Paypal, make "postback" requests. This requires developing
on a machine that can handle inbound HTTP connections from the internet.

 - This may require developing on your VPS.
 - Don't develop in production mode.
 - Open port 4000 and set your initial callback URL to be
   the dev server on port 4000 - this lets you use "mix phx.server"
   or "iex -S mix phx server" normally.
 - Don't develop as your production user. This is a good use for your
   non-root personal login account (e.g. log in as yourself)
 - See if your editor supports editing remote files over SSH. Emacs does.

