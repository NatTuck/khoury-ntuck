---
layout: default
---

## First Thing

Homework questions?

## Project Assignment

Two phases:

 - "Design" - Due in two weeks.
 - "Crunch Time" - Due in 4 weeks, at 11am (before class)
 - We'll be doing presentations a month from today.
 - You have plenty of time, use it effectively.
 
Tips:

 - Get something working and successfully deployed, then iterate.
 - Take advantage of the testing infrastructure. Tests are not required, but
   having at least some tests will actually make you move faster.

Design Phase:

-- Experiments:

 - You need to write three programs that *are not* your project.
 - These should sanity check parts of your design.
 - Check service API's you're using. Get keys, verify you can really connect, etc.
 - Check platform API's you're using. Does HTML5 Location really work?
 - Three experiments are required, but you may want to do more.

-- Design Document:

 - Describe the refined design of your app:
   - User stories.
   - Data design.
   - By page
   - Experiment results
 - This course is "writing intensive", so the design document is expected to be
   well written English text. There should be significantly fewer bulleted lists
   than on the course site.

## Web APIs

Two cases:

 - Browser to Server comms. We saw this for "Likes".
 - Server to Server comms. This is the topic today.

## REST w/ JSON Endpoints

We looked at RESTful routes early in the semester. Probably the
most common API style today is RESTful routes + JSON.

 - Show reddit.com/r/aww
 - Show reddit.com/r/aww.json

With REST-style paths, we have a reasonable interface for programatically
accessing and manipulating resources.

I'd like to print out titles from /r/aww

Create a new elixir app:

```
$ mix new aww_titles --sup
```

Add some deps to mix.exs

``
  {:httpoison, "~> 0.13"},
  {:poison, "~> 3.1"},
``

Now "mix deps.get", and let's test this out in "iex -S mix".

```
iex>  resp = HTTPoison.get!("https://www.reddit.com/r/aww.json")
iex>  data = Poison.decode!(resp.body)
```

Here's some code.

```
  # Add to aww_titles.ex 
  def reddit_list(sub) do
    resp = HTTPoison.get!("https://www.reddit.com/r/#{sub}.json")
    data = Poison.decode!(resp.body)
    data["data"]["children"]
  end

  def get_titles(sub) do
    xs = reddit_list(sub)
    Enum.map xs, fn x ->
      x["data"]["title"]
    end
  end
```

Reddit API:

https://github.com/reddit/reddit/wiki/API

 - API Terms
 - OAuth Required
 

### OAuth

https://apigee.com/console/reddit

Sometimes an app that uses an API needs to be able to get access to
a user's account on the remote service. 

OAuth is a protocal that allows a user to delegate access to their account
to a third party service.

To a user, it looks like this:

 - We start at the API Explorer (some app using the API).
 - We click an "authenticate with Github" (github is API provider) link.
 - We get an "API Explorer wants access to your Github Account, Ok?"
 - Clicking OK gets us back to API explorer, which now has access to our Github account.
 
To the app it looks like this:

 - We send the user off to Github.
 - They come back on a GET request including a single use code.
 - We POST to Github with that code, and get back a token.
 - We can use that token in API requests to access resources private to the user.

### Tokens

If you have an account with a service and are trying to authenticate to use
that account, you'll frequently get a token.

Send this token with each request, either in some sort of API-KEY header or
as the password for some sort of HTTP auth.

### Cryptographic Keys

Same use case as Tokens. We're trying to authenticate ourselves to the API.

In this case we use cryptographic keys instead of a token, which is somewhat more
secure but requires a bit more work.

Examples:

 - TLS Client Keys
 - HMAC
 - RSA signature


## Vultr Derp

 - Show Vultr API docs.
 - Show Buzzard app. Look at lib/buzzard/vultr.ex
 - Modify page_controller to show subdomains on web page.

## Web API Formats

GET

 - JSON
 - XML
 - Random nonsense

POST

 - Form data
 - JSON
 - XML
 - Random nonsense


