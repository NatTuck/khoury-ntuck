---
layout: default
---

4550 is 11:45 to 1:25

## First

Project questions?

## JS Frameworks

### Motivation

 - Starting point: NuMart reviews
   - Some scenarios *require* some sort of client-side HTML generation. 
   - Then you want two templates:
     - One on the server for the initial page load.
     - One on the client for when the page is updated.
   - Client side templates pretty clearly seem to be the more general of the
     two options: They can handle the "no communication" case.

Plan A: Let's use Handlebars for Everything

 - No server side templates at all.
 - Instead, we have Handlebars templates for each page and partial.
 - First load takes two RTTs:
   - First, to load the JavaScript + Templates
   - Second, to load the data to stick in the templates (AJAX).
 - No need to ever do another full page load.
   - Entire app is loaded on first request.
   - Links just change which template we see.
 - Complications:
   - That's a lot of templates, we should put them in seperate files.
   - We have separate "pages" in our app:
     - Need routing.
     - Need a place to put logic: Controllers
   - The back-end API is structured by resource, not nessisarily by
     visual page on the site.
   - Data might not line up perfectly, it might be useful to cache
     data from the server on the client - no need to request a record
     we just created, for example.
 - Result: A Full Client Side Framework (in this case, Ember.js)

### Ember.js Example

 - Ember is build assuming that your JS front-end and server side back-end
   can really be thought of seperately.
 - It has its own command line tools to generate new apps, generate components,
   run an auto-reloaded dev server, etc.
 - Since it expects to run its own server in dev, using a Phoenix backend runs
   into AJAX CORS security limits. This needs to be worked around by sending a
   CORS header.

Getting started, generate backend app:

 - We can run "mix phx.new --no-brunch -no-html".
 - Setup DB as usual.
 - Generate resources as JSON.
   - Possibly use the ja_serializer generator: https://github.com/vt-elixir/ja_serializer
 - Fix routes to handle json-api structure.
 - Fix CORS
 - Run the dev server
 
Generate frontend app:

 - ember new app
 - app/adapters/application.js
 - create route for tasks: "ember g route tasks"
 - app/router.js
 - app/templates/index.hbs 
 - app/templates/application.hbs
 - app/index.html
 - app/templates/tasks.hbs
 - app/routes/tasks.js
 - Model: Each path has one piece of associated data.
   - Possibly from the server, but not nesissarily.
 - The store: a cache of objects available on the
   backend. Allows async CRUD.
 - app/templates/components/task-form.hbs
 - app/components/task-form.js
 - app/controllers/task.hbs
 - Note real-time sync between the model and the
   new unsaved item.

### Heavyweight JUS Framework

Disadvantages:

 - Complex
 - Opinionated
 
Advantages:

 - Two way binding is useful.
 - Well defined structure which scales to very complex
   individual pages.
 - UI structure is not constrained by backend app structure much at all.
 - Fast and smooth once loaded

