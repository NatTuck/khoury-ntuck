---
layout: default
---

# First Thing

 - Proposal / Project Questions?

# Adding Passwords to HuskyShop

start branch: 7-suggested; end branch: 8-passwords

Where were we?

 - We store password hashes in the database.
 - Do password hashing with a password hashing algorithm.
   - Use a salt.
   - This actually sounds like something there's a library for.
 - Require minimum password lengths.

Add the comeonin library and Argon2 password hash algo:

```
  # mix.exs deps
  {:comeonin, "~> 4.1"},
  {:argon2_elixir, "~> 1.3"},
```

Fetch deps; create migration:

```
$ mix deps.get
$ mix ecto.gen.migration add_passwords
```

In the new migration file:
```
  def change do
    alter table("users") do
      add :password_hash, :string
      add :pw_tries, :integer, null: false, default: 0
      add :pw_last_try, :utc_datetime
    end
  end
```

Migrate!

```
$ mix ecto.migrate
```

**Show changes to user schema file**.

Add passwords to the seeds file:

```
pwhash = Argon2.hash_pwd_salt("pass1")

Repo.insert!(%User{email: "alice@example.com", admin: true, password_hash: pwhash})
Repo.insert!(%User{email: "bob@example.com", admin: false, password_hash: pwhash})
```

Reload from seeds:

```
$ mix ecto.reset
```

Update the user form:

```
   <div class="form-group">
    <%= label f, :password, class: "control-label" %>
    <%= password_input f, :password, class: "form-control" %>
    <%= error_tag f, :password %>
  </div>

  <div class="form-group">
    <%= label f, :password_confirmation, class: "control-label" %>
    <%= password_input f, :password_confirmation, class: "form-control" %>
    <%= error_tag f, :password_confirmation %>
  </div>
```

Update the login form (app layout):

```
<%= form_for @conn, Routes.session_path(@conn, :create),
         [class: "form-inline"], fn f -> %>
  <%= text_input(f, :email, class: "form-control col-4",
    placeholder: "email") %>
  <%= password_input(f, :password, class: "form-control col-4",
    placeholder: "pass") %>
  <%= submit "Login", class: "btn btn-secondary" %>
<% end %>
```

Validate the password on login (session\_controller):

```
  def create(conn, %{"email" => email, "password" => password}) do
    user = get_and_auth_user(email, password)
    ...
  end
  
  # TODO: Move to user.ex
  def get_and_auth_user(email, password) do
    user = HuskyShop.Users.get_user_by_email(email)
    case Comeonin.Argon2.check_pass(user, password) do
      {:ok, user} -> user
      _else       -> nil
    end
  end

  # TODO: Throttle Atttempts
```

# Webapp Security

NIST Guidelines: https://pages.nist.gov/800-63-3/

## Your Web App is Network Accessible

This means that your site can be accessed by over a billion people, who are
effectively anonymous.

They can send any network packets they want to your server. It's up to you
to make sure that people with internet access can't get your server and the
applications running on it to do things you don't want.

One way to look at internet servers is that they provide a publicly 
accessible interface, controlled by the developers and administrators. In this
view the idea that some people are "hackers" and are doing something wrong
is silly. If you didn't want them doing it, you shouldn't have hooked up a
server that provided that option.

In general, a key idea is to be careful with user input. If you have data
that came from a remote request, assume it's out to get you and don't pass
it on to any potentially dangerous API calls without carefully considering
how things could go wrong.

## Sessions

 - Sessions should be invalidated when a user logs out.
 - Sessions should time out. Consider appropriate timeouts for your app.
   - Trusted computers vs. public computers. Consider asking the user, default public.

## Internal App Security

You want to make sure that your application enforces its own rules.

Examples:

 - Only a user can edit their own posts.
 - Only a user can view their private messages.
 - Only an administrator can set another user to be an administrator.

It's up to you as an application developer to figure out what these rules are
and make sure your application enforces them.

For your project, you want to make sure you've considered this. Security flaws in
your application logic will be something we're looking for in grading.

### HTTPS

 - HTTPS is a secure variant of HTTP, running the connection through the TLS protocol.
 - TLS does two things:
   - Encrypts the data in transit.
   - Authenticates one or both ends of the connection.
 - Normal usage is that the server has a cryptographic certificate identifying it,
   issued by a trusted party called a Certificate Authority.
   - e.g. amazon.com is authenticated by Symantec Corporation
   - Certificate authorities are validated by certificates included with your
     web browser or operating system. Firefox authenticates Symantec authenticates Amazon.
 - Authentication is more important than encryption.
   - Encryption gurantees that no-one's snooping on your connection.
   - Authentication guarantees that you're connected to who you think you are.
 - No auth = Man in the Middle attack. Someone gets you to connect to them, and then they
   connect to your real destination and relay stuff back and forth.
   
## Let's Encrypt

In order to set up HTTPS, you need a certificate issued by a trusted CA. This used to
involve paying $75. Then $15. Luckly, there's finally a reasoanble free option.

https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx

Show setup for webshop.ironbeard.com:

 - Get the certficate with certbot (/root/...renew.sh)
 - Add a server block for 443 ssl (/etc/nginx/sites-available/webshop...)

You can eliminate non-SSL connections by having your :80 server block redirect
to the https URL.

## Strict Transport Security

https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security

 - People don't really notice HTTPS mode.
 - So if an attacker can get people to connect via HTTP, they can MITM all the want.
 - Modern browsers allow servers to request always-HTTPS with the
   Strict-Transport-Security.

If a browser gets the header (that's one month in seconds):
 
```
Strict-Transport-Security: max-age=2592000
```

Then it will refuse to connect to to that host by HTTP for one month. This is reset
on every connection, so if your users visit your site at least once a month they'll
always ben in HTTPS-only mode.

You can't change your mind. Once you've sent the header, clients are stuck in
HTTPS-only mode until they haven't seen the header for the set duration.

 - I recommend not doing this for personal / class projects.
 - It's important to do it for situations where security matters.

### Certificate Pinning

The "Public-Key-Pins" header can be used to pin a specific TLS certificate as the
only valid one for a domain. Once a browser sees the header, they won't accept
new certificates for a time.

This is similar to Strict Transport Security, but stronger and easier to mess up.
If you lose your cert key, your website is just broken until this times out.

## General Attacks

### Too Broad an API

Consider a form to download a file:

```
<form action="/download" method="post">
<select name="file">
  <option>foo.txt</option>
  <option>bar.jpg</option>
</select>
<input type="submit">
</form>
```

This should send something like "file=foo.txt" as one of the request
parameters. Then your app will open "file.txt" in the appropriate
directory and send it along.

What if the user sends a POST request asking for "file=/etc/tls/cert.key".
Your app goes ahead and opens the file and sends it along. And the attacker
has your HTTPS private key and can impersonate your server.

The two approaches to mitigate this issue are:

1. Indirection. Send "file_id=7" instead, and look up the name of the file
   in the legal_downloads table in your database.
2. Sanitize the input. Verifiy that the input has no slashes, or dots, or
   tildes in it before opening the file. This works if you catch every bad
   case, but that can be hard.

### Cross Site Request Forgery (XSRF) Attacks

 - Users in web apps are generally authenticated by session cookies.
 - Any time a user with an appropriate cookie in their browser makes
   a request to the server, they're authenticated by the cookie.
 - Forms on web sites are submitted as a HTTP POST request.
 - Nothing stops somoene from making a form on another web site that
   has an "action" attribute pointing at your server.
 - When a user submits the form on the other site, if they're already
   logged in on your site, they're an authenticated user making an
   apparently legitimate request.
 - The form doesn't have to be visible and can be triggered by JavaScript.

Example:

 - Imagine your home router can be administered from a web browser.
 - It has a form to change the admin password.
 - It has a form to enable access from the public internet.
 - The router always lives at http://192.168.1.1/
 - You visit a cat video on haxxor.fi, and those dasterdly Finnish hackers have
   a hidden form on the page: 

```
<div style="display: none;">
<form id="hax" action="http://192.168.1.1/change_admin_password" method="post">
<input type="hidden" name="new_password" value="haxxor.fi">
</form>
</div>

<script>
  $(function() { $('#hax').submit() });
</script>
```

The page inexplicably reloads. The next page has another form.

```
<div style="display: none;">
<form id="hax" action="http://192.168.1.1/allow_remote_access" method="post">
<input type="hidden" name="allow_remote_access" value="1">
</form>
</div>

<script>
  $(function() { $('#hax').submit() });
</script>
```

And your cat video plays. And now haxxor.fi controls your router. Interestingly,
your bank website now doesn't use HTTPS. They probably should have enabled strict
transport security.

Solution: XSRF tokens. Include a unique token in each form and then verify that
each form submission has a valid token.

Note that AJAX can't be easily used for XSRF attacks. Browsers ban cross-site
AJAX by default.

### Cross Site Scripting (XSS) Attacks

With XSRF tokens and cross-site AJAX restrictions, hijacking someone's session
is inconvenient.

Unless you can run JavaScript that's served as part of a web page on the target
site.

Consider a version of your Microblog app that allows people to type in HTML for
their messages.

If somoene types in a message like:

```
<div id="worm">
<p>Buy discount rolex watches at discountrolx.fi!</p>
<script>
$(function () { $.ajax(... path: "/messages", method: "post", data: $('#worm').html(), ...) });
</script>
</div>
```

Now everyone who views the message posts the message. This happened on MySpace
several times. Bing "myspace worm".

Solution: Any user supplied content needs to be filtered to eliminate anything that
will be treated as special in an HTML document. Most modern web frameworks do this
automatically - it's a bit tricky to do by hand.

Sometimes you *do* want to allow HTML. This is way more annoying. You'll want to
whitelist safe tags an attributes rather than blacklisting unsafe ones, and even
simple links are unsafe.

### SQL Injection Attacks

Imagine a user logs in to your website, and you get "email" and "password"
in your controller.

You then say:

```
  user = SQL.execute("select * from users where email = '#{email}' limit 1");
```

The next thing that will happen is that someone will give you

 email = "'; delete from users;"
 
And now you don't have any users. Don't do that. Use tools like Ecto
for DB queries, and if you must execute custom SQL commands find the
API for "parameterized queries".

### Client Side Input Validation

Consider the rule that a password must be at least 8 characters.

When someone registers a new account, they type in a password. You have two options
for validation when they click the submit button:

 * Check that the password is at least 8 characters in JavaScript, and stop the
   submission with an error indicator if it's not.
 * Check that the password is at least 8 characters on the server, and display
   an error page (or the form with an error indicator) if it's not.

Doing the first provides fast user feedback, and variants can produce a better
user experience.

Doing only the JS validation doesn't guarantee that everyone has an >= 8 character
password. Users can turn off or modify your JS, or submit HTTP requests manually
without a browser.

You want to do input validation server-side. You may *also* want to do client side
validation, but only for UX, not for data consistency.

## The Moral of the Story

Security is about understanding what capabilities your application exposes
to users and the internet in general. Once you know what people can do, you
can decide which of those things you don't want them to do and change the
system so they can't do them.

This is one of the reasons it's important to know about and understand all
the moving parts in a web application. If you know what everything does, then
you can make sure it's doing what you want - and not other stuff you don't want.

