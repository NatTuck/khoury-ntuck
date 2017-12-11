---
layout: default
---

## First Things

 - Battleship Questions?
 - Double check grades. Once grades are out it's too late.
 - TRACE

# CS4550, Web Development

## Web Development

Web App Picture:

 - Several web browsers.
 - Connect to several web servers.
 - Connect to one DB server.

== Back End ==

 - Browser makes request to Web Server
   - Web server hits DB
   - Web server calculates response
 - Server responds with HTML

== Front End ==

 - Browser requests CSS / JS / Images
 - Server responds with assets
 - Browser renders page
 - Browser runs onload JS

### The Basics

 - HTML
 - CSS; Bootstrap
 - Simple JS; jQuery
 - HTTP 1.0: GET vs. POST

Operations:

 - Running a Linux Server
 - Basic security (don't allow root password logins)
   - We had one student "get hacked" this semester.
 - Static Hosting with Nginx

### New Language: Elixir

 - Functional Dynamic Language like ISL
 - Atomic Data: Number, String, Atom
 - Data Structures: Tuple, List, Map, Structs
 - Syntax: Pattern Matching, LISP2
 - Erlang VM; Lightweight Processes, Message Passing
 - "Let it Crash"
 - OTP: GenServer, Supervision Trees
 - Can do all of this distributed across multiple machines

### User Centric Design

 - User Stories
 - Figure out how users use your site.
 - This is the core design methodology to talk about with non-technical people.

### Data Centric Design

 - Which resources do we need?
 - Resources map nicely to both structs / objects and DB tables.
 - DB references / normalization
 
RESTful Resources / Routes:

 - Index
 - Show
 - New Form
 - Create
 - Edit Form
 - Update
 - Delete

### Web Apps with Phoenix

There are many traditional style server-side web frameworks. We used this one.

 - Each request is to some route.
 - That brings us to a controller function to handle the request.
 - Controllers are generally associated with a resource, represented
   by a schema and a datastore accessible through a context module.
 - After performing any work, the controller delegates rendering to
   the view (which generally renders the associated template).

This is almost "MVC" style, but there's not really a model.

Operations:

 - Building an Elixir app release with distillery.
 - Deploying to a Linux / Nginx server.
 - This wants to be automated and *needs* to be documented.
 - Key Lesson: Deployment can be non-trivial; it's something
   you want to pay attention to early.
 - An app that can't be deployed isn't especially useful.
 
### Data Persistence

Cookies
   
 - Maintain client sessions
 - Strategy A (Elixir): Signed Map
 - Strategy B (???): Random session key into DB

Data Store: PostgreSQL

We glossed over the database a bit; we saw

 - Tables / Schemas
 - Foreign Keys
 - The Ecto library

One thing we didn't cover is datastore alternatives.

A RDBMS like PostgreSQL provides:

 - Enforced schemas and foreign keys
 - Server-side joins
 - Atomic transactions
 - Consistency guarantees
 - Durability: Once a write is accepted, power loss won't lose it.
 - Fast indexes

This comes at a cost: Bad horizontal scaling. You can't just add more
DB servers to go faster.

 - Draw it.
 - Any master: old replicas, sequential writes.
 - No master: write conflicts.

As long as we insist on consistency, we're stuck with these properties.

NoSQL: Who needs consistency, schemas, or joins?

 - Sometimes slightly old data is fine (Facebook profile photo).
 - Sometimes write conflits are fine (Facebook profile photo).

The most common kind of NoSQL database is a document store.

 - Rather than tables, we just have one or more key -> value maps.
 - Keys are usually strings.
 - Values are usually JSON objects.

Reading old values is generally considered fine. It's just like you were
a couple milliseconds back in time.

Write conflicts are generally tunable. Either you accept them and have a
conflict resolution scheme or you require majority-confirmation on writes.

You can't really do server-side joins, since you have no schema.

Indexes are annoying. You sometimes have to write your own document -> index value
functions.

Durability is generally just skipped for performance.

Examples:

 - CouchDB - Written in Erlang for extra neatness.
 - MongoDB - Known for eating your data.

### Asynchronous Comms

You can go pretty far with a simple CRUD app based on the default resource-based
paths and pages, but as things get more complicated it's useful to talk to the
server without a page reload. For this you have two options:

"AJAX" requests:

 - Do an HTTP request to the server, following normal resource path conventions,
   without triggering a page load.
 - Get the response in a JS callback.
 - Probably use JSON to transfer data (in spite of X = XML).

Websockets:

 - Have a persistent TCP connection open from client to server.
 - Either side can send messages and respond, triggering callbacks on
   both sides.
 - Allows server to push updates to client.
 - Doesn't require a new connection for each request.
 - May occasonally lose connection, especially on moble, and need to reconnect.

Broad browser support for websockets is pretty recent, and I expect it to become
very common in web apps. It requires a somewhat different programming style server-side
though because it's stateful. The websocket will stay open as long as the page is open
in a browser.

### Web APIs

 - Services frequently expose their resources via a public or semi-public Web API.
 - Semi public means auth: Usually Oauth or Token.
 - This frequently looks a lot like the resources layout we started with.
 - Everyone hit an API for their project.

### Front End Frameworks

The most hyped thing in web dev nowadays is front end frameworks.

I know some of you were hoping we'd work with "MEAN Stack", where
MEAN = MongoDB, Express.js, AngularJS, and Node.js.

Instead I ended up promoting Postgres, Elixir, React, and Phoenix. Which 
is much better, because you'd sound lame taling about the "PERP stack".

Traditional web applications are fine for a lot of stuff, but as an app
gets more complicated and you want more control over the UI, the SPA model
does become useful.

Tools like React, Angular, Ember, or even GWT where you can write web UIs
in Java all do the job. Just keep in mind:

 - Only the UI should run in the browser unless you're intentionally building
   Cookie Clicker.
 - You don't control the browser execution environment. People can, and will,
   run Greasemonkey scripts or similar.

### Summary

Web development is the general case distributed programming
problem.

 * Browser <-> Web Server
 * Browser <-> Remote API
 * Web Server <-> Remote API
 * Web Server <-> Web Server
 * Web Server <-> Local API

And that's *before* we start considering front-end issues.

 * UI Design

### Battleship

 - Note client / server split:
 - Really wants JS page rendering.
 - *Needs* websocket push.
 - Needs server-side game logic.
 - Anyone have it working?


 
