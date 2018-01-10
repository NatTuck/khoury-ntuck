---
layout: default
---

## First: HW Questions?

 - I'm going to go over configuration of Nginx virtual hosts.


# More on HW01

## Setting up Nginx Virtual Hosts

### Starting Point

 - A VPS running
   - Software firewall enabled
   - Non-root user with ssh key and sudo working.
   - SSH logins disabled for root 
 - A domain name, with two subdomains pointed to the vps:
   - www.ironbeard.com / ironbeard.com
   - hello.ironbeard.com
   - show joker DNS config page with this config
   - show TTL under options - that's 24 hours

### Set up the server
 
As the root user:

    sudo apt install nginx
    cd /etc/nginx/sites-enabled
    vim default

 - Change "root" to /home/name/www/main
 
    service nginx restart

 - (as normal user) Create /home/name/www/main/index.html
 - Visit the server IP

Testing while waiting for DNS:

 - Create an entry in /etc/hosts for the site.

Let's set up another web site too.

 - (as root) Save off the template below in /etc/nginx/sites-available
 - Edit the root and server name (ironbeard.com)
 - Symlink the config file to /etc/nginx/sites-enabled
   - ln -s /etc/nginx/sites-available/ironbeard.com /etc/nginx/sites-enabled
   - ls -l /etc/nginx/sites-enabled
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



# Web Tech Overview

## HTTP

### HTTP/1.0 (1996)

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

## Some Historical Web Apps

 - WebCrawler (1994) (C / CGI)
 - UBB message board (perl / CGI)
 - Slashdot (Perl - embed interpreter)
 - phpBB (PHP - embed interpreter)
 - Reddit (LISP then Python - separate server) 
 - Final tech piece: Reverse proxy
 
 - OpenOffice Online
   - Client Side: JavaScript that doesn't do much.
   - Server Side: C++, including rendering
 - Gmail
   - Client-side: Java
   - Server-side: Java
 - Facebook
   - Client-side: JavaScript and React.js
   - Server-side, main application: PHP
   - Server-side, secondary services: C++, Java, Python, Erlang

## Options

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


## Unused Notes

https://conference.libreoffice.org/2015/the-program/talks/development/
