---
layout: default
---

# The Web

What is the web?

 - Protocols: HTTP, URLs
 - Content Standards: HTML / CSS / JS
 - Data Conventions: JSON, REST
   
What is web development?

Key Element: HTTP

# Web Development

Standard web app:

 - Browser makes HTTP request to server
 - Server generates & sends HTML / CSS / JS
 - Browser renders page
 - (optional) JS executes on in browser
   - Maybe changes the page.
   - Maybe makes more requests.
 - User clicks a link/button on the page.
   - Browser makes an HTTP request to server
   - Server generates a new page...

Deeper Picture:

 - One server?
 - Multiple servers:
   - Web Server
   - Database Server
 - Scaling:
   - Multiple web servers
   - Load balancer
 - Application servers?
 - Three tiers
   - Web
   - App
   - Database

# Overhead

 - Class Web Site
   - Notes, show today's notes
 - Piazza
 - Bottlenose

 - Schedule
   - Lectures: Build an online store
   - Homework: Build a microblog service

 - Project: 
   - Build a moderately complicated web app.
   - Teams of one or two.
   - Start trying to find a partner now.

# Web Tech Overview

## HTTP

### HTTP/1.0

HTTP 1.0 was entirely stateless.

 - Two methods: GET, POST
 - No concept of "session".
 - Server doesn't know that two requests come from the same browser.
 - No way to have multiple sites per IP.

Example: (end the GET with two newlines)

```
$ telnet seagull.ccs.neu.edu 80
GET / HTTP/1.0
```

### HTTP/1.1

New methods: PUT, DELETE, PATCH, HEAD

Add Host header to support multiple sites.

Example: (end the GET with two newlines)

```
$ telnet seagull.ccs.neu.edu 80
GET / HTTP/1.1
Host: seagull.ccs.neu.edu

$ telnet seagull.ccs.neu.edu 80
GET / HTTP/1.1
Host: example.com

```

HTTP 1.1 is still stateless, but adds "cookies".

 - Cookies are (name, value) pairs that are sent from the server to the client in
   the HTTP response.
 - The client (browser) is supposed to send back all the cookies with future requests
   to the same site.
 - A "site" is a (host, port) pair.

### SSL / TLS

SSL1: No way to have multiple sites per IP, even with HTTP/1.1

All SSL: Insecure.

TLS2.1: Current version, probably secure if you don't configure
insecure crypto algorithms.

### HTTP/2.0

 - Think of it as a fast version of HTTP/1.1
 - Binary protocol
 - Allows multiple concurrent requests on one connection
 - Browser implementations require TLS
 
### WebSockets

 - Think of it as TCP over HTTP
 - Allows long duration bidirectional communication
 - With an open websocket, the server can send a message to the client
 - Allows real-time behaviors in web apps.

## Browser Content

HTTP just lets clients request URLs from servers.

A URL generally contains a file, possibly generated dynamically.

Some specific types of file are broadly supported by web browsers,
and those make up normal web content.

Users update browsers slowly, or don't realize that they can download
a browser that isn't Internet Explorer. You can see what fancy features
are supported in which browsers at: http://caniuse.com

### HTML

 - Most browsers support HTML3 from the 90's.
 - It's generally safe to use a subset of HTML5.
 - Which subset? No idea. Have fun.

### CSS

 - Most browers support a superset of CSS1.0
 - Specific features from CSS2 or CSS3 may have broad support.

### JavaScript

 - Most browsers support some superset of ECMAScript 3 (ES3) from 1999
 - Your browser supports ECMAScript 5 (ES5) from 2010
 - Browsers are working on support for ES6

JavaScript isn't a terrible language, but many developers prefer working
in other languages. It's common to compile to JavaScript.

 - We'll get to use ES6 compiled to ES5 later.
 - CoffeeScript
 - TypeScript
 - ClojureScript
 - Dart
 - Elm

### Images

 - PNG (Lossless compression, good for "simple" images)
 - JPEG (Lossy compression, good for photos)
 - GIF (256 colors only, but supports animations)

### Other Stuff

 - Video
   - No single format with 100% support. H.264 and WebM come closest.
 - Audio
   - MP3 should work everywhere.
   
## Server-side Programming

Client-side we run JavaScript.

Server side, we just need a program that responds to HTTP requests.

History:

 - CGI (Perl)
 - Web Server Hooks (PHP)
 - Write a Web Server, reverse proxy to it.

Additional concerns:

 - Frameworks / Languages
 - Data persistence (usually a database)

Stacks:

 - LAMP: Linux, Apache, MySQL, PHP
 - .NET: Windows, C#, MSSQL, etc
 - Java: Linux, Whatever server-side Java uses
 - MEAN: Linux, MongoDB, NodeJS - JavaScript everywhere!
 - RoR:  Linux, Ruby, Rails, Posgres/MySQL, a server?

Modern Decision Tree:

 - Microsoft?
 - Java?
 - Pick a framework and DB

Framework / Languages choices:

 - Framework: Heavy vs. Light, Opinionated vs. Flexible
 - Language: Performance
   - Native code: C, C++, Rust
   - Native code + runtime: Go, Haskell
   - Heavy VMs: Java, .NET
   - "Fast" scripting languages: JavaScript, Lua
   - Scripting languages: Perl, Python, Ruby
 - Specific features 

Database choices:

 - SQL vs. NoSQL

This semester we're going to use Elixir/Phoenix/PostgreSQL

# Hosting a Static Web Site

## Initial stuff

- Set up a VPS
  - Walk through the process on vultr
  - Set an SSH key
  - (you can generate a key with "ssh-keygen -t rsa")
- Register a domain (use ironbeard.com)
  - Point it (including www.) to the VPS's IP addr
  
## Set up the server
 
First, secure the server.

- Log in to the server (ssh root@ip)
- Enable the software firewall


```
ufw allow 22/tcp # important, this allows ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 4000/tcp
ufw enable
```

- Create a non-root user.
  - adduser name
    - Set a good password
  - adduser name sudo
  - su - name
  - add your ssh key to ~/.ssh/authorized_keys
  - Test ssh login in separate terminal window
  - Test sudo
  
- Disable root ssh (/etc/ssh/sshd_config; PermitRootLogin)
  - Test that.
 
Next, set up the web server.

    sudo apt-get install nginx
    cd /etc/nginx/sites-enabled
    vim default

 - Change "root" to /home/name/www/home
 
    service nginx restart

 - (as normal user) Create /home/name/www/home/index.html
 - Visit the server IP

Testing while waiting for DNS:

 - Create an entry in /etc/hosts for the site.

Let's set up another web site too.

 - (as root) Save off the template below in /etc/nginx/sites-available
 - Edit the root and server name (site2.ironbeard.com)
 - Symlink the config file to /etc/nginx/sites-enabled
 - Restart nginx
 - Create hosts entry and test that.

sites-available/ironbeard.com :

```
server {
        listen 80;
        listen [::]:80;

        root /home/nat/www/ironbeard.com;

        index index.html;

        server_name ironbeard.com www.ironbeard.com;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }
}
```


