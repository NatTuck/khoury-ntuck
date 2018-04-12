---
layout: default
---

## First Thing

 - Project 2 Questions?
 - Do your TRACE

## Semester Review

 - Big Picture: 
   - {Development} ∩ {HTTP}
 - Core Technologies: 
   - HTML, CSS, JS
 
```
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  
  <!-- styling -->
  <link rel="stylesheet" href="app.css">
  
  <!-- dynamic behavior -->
  <script src="app.js" defer></script>
  
</head>
<body>
  <h1>Hello, HTML</h1>
  <p>This is an HTML document</p>
</body>
</html>
```
   
   - HTTP 
     - ```python3 -m http.server```
     - ```GET / HTTP/1.0```
   - We want to do two things:
     - Make the server return stuff dynamically.
     - Make the JavaScript more complex.

 - Asset Pipeline
   - brunch (... webpack)
   - babel/ES6
     - There are fancy new JS features that may not be supported in browsers.
     - We can use them anyway by adding a transpiler.
     - The same strategy can be used to use whole other languages, like
       Elm or ClojureScript.
   - sass/SASS
     - We're preprocessing our JS, might as well do the same for CSS
 - Web Page Rendering
   - Server-side Templates
   - React: Building a DOM Tree
     - We can build a pure (no side effects) rendering function that
       transforms state -> DOM tree (= web page).
     - This allows us to build dynamic web UI using programer-ish techniques
       in a way that lets change be efficient.
 - Erlang & Elixir
   - Reliability => Distribution
   - Implies: Concurrency => Scalability
   - If you have the opportunity over the summer, try out distributed
     Elixir.
 - Phoenix Framework
   - Structure: RESTful Routes
   - Structure: Router / Controller / View / Template
   - Tool: Sessions
 - Websockets
   - Phoenix Channels
   - This lets us have real distributed applications with
     updates flowing server -> browser.
   - Project 1 was a game: Websockets make this really feasible.
 - Relational Database & Resources
   - Structure: Tables, References
   - Concrete DB: PostgreSQL
   - Ecto Schemas
   - Ecto Relations
 - Other Database Alternatives
   - Other SQL databases are basically the same.
   - I claimed that distributed SQL doesn't exit, but there are
     now some attempts at this. Consider looking at CockroachDB.
   - NoSQL datbases exist. Erlang even has one built-in: Mnesia.
 - JSON APIs
   - RESTful routes
   - AJAX
 - Canvas; React-Konva
   - WebGL is a thing.
 - Security Issues
   - Attacks: XSS, XSRF, Code Injection
   - HTTPS
   - Passwords
 - Single Page Apps
   - Avoids page loads.
   - Router / View / Template in browser.
   - Either AJAX or Websocket
   - Client side state: Redux
 - Using Web APIs
   - OAuth2
 - The Future: Web Assembly
   - Non-JS Browser Code
     - Non HTML/CSS UI
   - High performance graphics
   - Heavy duty compute
 - And then we reviewed the semester

## Broad Goals

  - Deployment
    - Everyone has their own (virtual) Linux server.
    - Every assignment includes deploying the application
      to the actual web.
    - Deployment can be tricky (until it's automated for
      your actual app).
    - The only way to make it hurt less is practice.
    - Result: You should be able to effectivley build and 
      deploy non-trivial web applications by yourself.
  - Technology changes quickly.
    - We worked with Phoenix and React this semester.
    - You will worth with other things in the future.
    - Learning new stuff is a skill that requires practice.
    - Result: When you get a job where you use Clojure/Ring,
      Cassandra, and Vue, you should be able to figure it 
      out.

## Last Stuff

 - Do your TRACE evals.
 - Next Tuesday in WVG is office hours.
 - Good luck on the project.
 - Have a good summer.

