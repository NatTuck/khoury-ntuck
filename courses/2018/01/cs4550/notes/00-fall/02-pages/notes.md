---
layout: default
---

# HW01 Catchup

Obvious content:

 - Basic HTML/CSS
 - Administering DNS
 - Setting up a web server
    
Incidental content:

 - The Linux command line
 - Administering a Linux system service
 - A command line editor
 - Dealing with a remote server over SSH
 - Git and Github
 - Running a local Linux VM

Everyone should be able to get the core tasks completed for the homework by the
extended due date tonight.

If your local VM has issues or you aren't comfortable with vim to edit server
config files or you haven't figured out SSH keys, those are worth spending some
time on over the next couple weeks.

# Bootstrap

http://getbootstrap.com/

First, save off the starter template (in Getting Started) as starter.html

Bootstrap Concepts:

## Opinionated Styles

 - Bootstrap provides a reasonable default set of styles for
   a web app.
 - We take advantage of this by structuring our page the way Boostrap
   wants us to, and then applying Bootstrap classes to our HTML
   to pull in appropriate styles.

## Mobile First

 - Boostrap encourages a style of treating phones as the default
   device. You then add special case layout rules for desktops.
 - This is good: otherwise you'd forget phones, which are apparently
   how kids these days use the web.
 - Devices are split into 5 classes: xs, sm, md, lg, xl

## Grid System

 - 12 column grid; this makes some layouts really easy
 - Frequently you want multiple columns on desktop, but only
   one on mobile.
 - To grid:
   - Wrap everything in div.container
   - A row is a div.row
   - A column is a div.col-md-X, where X is how many of the
     12ths of the screen wide it should be.
   - The "md" means columns only on "medium" screens or bigger.

Example:

```html
<div class="container">
  <div class="row">
    <div class="col-md-8">
      <p>This column is 2/3rds of the width.</p>
    </div>
    <div class="col-md-4">
      <p>This column is 1/3rd of the width.</p>
    </div>
  </div>
</div>
```

## A Whole Bunch of Widgets

Point out:

 - Content: table, table-striped
 - Components: buttons, cards, forms, navbar (at the top)
 - Utilities: text / text-truncate

Everyone should go through the whole bootstrap site, just to
see what kind of UI elements it makes easy.

# WebShop Design

Resources:

 - Products
 - Users

"RESTful Routes" Pages:

 - create - after item created
 - show   - show an item
 - update - after item updated
 - delete - after item deleted
 - edit   - form to edit item
 - new    - form for new item
 - index  - list of items

Let's make the pages for products.

Spin up a local server: python3 -m http.server 8000

First, the template.

Edit the Boostrap starter page into an app template:

 - Navbar
 - Container
 
Create the sample pages:

 - (create, new) = form
 - show
 - index
 
We can skip these:

 - update - show with message
 - delete - index with message
 - create - show with message
 
# Deployment

 - webshop.ironbeard.com subdomain already set up
 - ssh-copy-id nat@ironbeard.com
 - scp -r pages nat@ironbeard.com:~/www/webshop
 - become root on coyote.ferrus.net
 - copy the fogcloud.org config to webshop.ironbeard.com
   - change the root and server_name
   - add "autoindex on" to the location block
 - enable with sites.pl
 - restart nginx

