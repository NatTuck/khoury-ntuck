---
layout: default
---
# Review: HTML and CSS Basics

 - Go through the simple example.
 - Mention the w3c HTML validator: https://validator.w3.org/
 - Talk about boxes in rendering in the Chrome debugger.

# Review: Setting Up a VPS & Static Server

 - Spawn a VPS on Vultr
 - Set up nginx for two sites.
 - Comment on security issues.
   - No root logins, after normal user exists & works.
   - Software firewall.

# Web Store: The Competition

If you're building an app that has been done before, it's really useful
to figure out what existing apps do. Let's go take a look at a web store.

 - Go to newegg.com
   - Page: home
   - Main content: products for sale
   - Other stuff: Product search, categories for browsing
 - Click a product
   - Page: a product
   - Main content: description, photo, order form
   - Order form: options, quantity, add to cart
   - Note: main nav, breadcrumbs

# User-First Design

In this design we figure out what users need to do with the app and
figure out what pages in the app they use.

To do this, we come up with a bunch of user stories that cover representitive
use cases for the app.

This sort of thing is frequently the result of a meeting with a non-technical
manager or customer who is requesting a new application. If in that situation,
it's important to avoid describing anything that an application user can't
see in order to maintain technical flexibility for development.

## Buy Two Things

"As a normal user, I can buy stuff from the store."

 - Alice visits the store home page.
 - She browses the available items.
 - She adds two items to her shopping cart.
 - She logs in or enters shipping info.
 - She checks out.
 
## Add a New Product

"As an admin, I can add a new product to the store."
 
 - Bob visits the store home page.
 - He logs in as as an admin.
 - He clicks "manage products" and "new product".
 - He fills in the form and saves.
 - He checks that the product looks right.
 
## Fulfill an Order

"As an admin, I can view outstanding orders and mark them shipped."

 - Carol visits the store home page.
 - She logs in as an admin.
 - She clicks "manage orders".
 - She views the first unfilled order on the list.
 - She clicks "mark as shipped".

# Data-First Design

RESTful Routes

I first saw this scheme in Ruby on Rails, but the Phoenix
framework has adopted it as the standard app structure as well.

It makes some sense for server-generated HTML sites. It makes
even more sense for JSON APIs as used by Single Page Applications
using a frontend app framework.

 - The web application manages a set of resources,
   or types of data stored in the database.
 - With a SQL database, each resource is a database
   table.
 - Each resource has four basic operations (CRUD):
   - Create
   - Retrieve (Show)
   - Update
   - Delete
 - Since each operation requires an HTTP request,
   we end up with one page per (resource, operation).
 - We also need a couple more pages per resource:
   - Index
   - New

So a good starting point is figuring out which resources
our app needs. This is a very similar problem to figuring
out what classes we want in an OO app.

For our web store, we'll want something like this:

 - Products
   - Name
   - Description
   - Picture
   - Price
 - Users
   - Email
   - Shipping Address
 - Shopping Carts
   - Reference to User
   - List of (product, count)
 - Orders
   - Reference to User
   - List of (product, count)

Questions:

 - Can a user have multiple carts?
 - Are orders and carts the same thing?

Suggested solution:

 - Shopping Cart
   - Reference to User
   - List of (product, count)
   - ordered?

Constrant: A user can only have one cart that hasn't been ordered.

Alternative: A user has an "active", unordered cart. The others are
saved as "wish lists".

"List of" doesn't really make sense in an SQL table, so we want to
split that out into a seperate table.

 - Items in cart
   - Reference to Cart
   - Product
   - Count

This is a separate database table, but it may or may not make sense
to treat it as a seperate resource. We'll say it's just part of the
Shopping Cart resource for now.

So we have four resources with six operations each, for a total of
24 pages we need to worry about.


