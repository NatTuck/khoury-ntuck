---
layout: default
---

# Some Final Project Ideas

## MBTA Next Bus Tracker

Concept: A app that lets you know when the next bus is going to show up
using the MBTA API.

Persistent state (in Postgres)

 - User accounts
 - Favorite bus stops

Realtime (with Channels)

 - Realtime bus info pushed to browser.

External API

 - MBTA API

The complicated part

 - Use the HTML5 Location API to find nearest bus stop candidates. Streaming a phone
   sensor through to the server is what makes this app interesting.
 - Proper testing will require going outside and standing at a physical bus stop
   holding a phone.
 - Probably wants multiple backup mechanisms for testing / GPS failure,
   like searching for stops by GPS location, searching by name, etc.

## Capture the Campus

App Description:

 - Use the Google Maps API to find the location of buildings at Northeastern
 - Use HTML5 geolocation to track player position
 - Games are between equal sized teams.
 - To capture a building, you need to stand next to it, press "capture", and
   wait for one minute.
 - If you come near a building being captured by your opponent, you can press a
   KO button to knock them out.
 - If you've been KO'ed, you need to walk over to Snell Library and press
   "Recover" to fix it.
 - First team to capture CCIS, COE, College of Science, and International Village wins.
 - Locations are sent to server and action buttons are enabled via websockets.

Persistent state (in Postgres)

 - User accounts
 - Per user win/loss record

Realtime (with Channels)

 - Game UI
 - Active game state in GenServer

External API

 - Google maps for building location data
 - Maybe google maps in browser as part of UI

The complicated part

 - You'll need to get together at least 4 people to do an interesting playtest.

## Scheduled SMSes

Concept: A web site that lets you send SMSes both in realtime and scheduled for
later.

Persistent state (in Postgres)

 - User accounts
 - Scheduled messages
 - Message history

Realtime (with Channels)

 - Replies to your SMS messages are displayed immediately.

External API

 - Twilio SMS API

The complicated part

 - Figuring out a good design for the site.
 - Making this work may require a paid account.
 - Process to verify source phone numbers?

## Vultr VPS Monitor

Concept: An app that shows your active Vultr VPSes and monitors
whether your apps are up. Extra neat would be being able to auto-deploy
a cluster of servers running some other web app.

Persistent state (in Postgres)

 - User accounts
 - VM info

Realtime (with channels)

 - Show VM state.
   - Is the VM turned on?
   - Does it ping?
   - Is there an HTTP server listening on port 80? 443?
   - What's the memory usage and CPU load?

External APIs

 - Vultr API
 - SSH to the server to get real-time performance stats.

The complicated part:

 - Connecting to the server to get the performance stats.
 - Should there be a persistent daemon running on each server, or can
   you get away without it?
 - Should this app have a "create server" button that uses a setup
   script to install the stats daemon?


## Other neat APIs

 * https://newsapi.org/
 * https://openweathermap.org/
 * https://www.alphavantage.co/
 * https://developers.coinbase.com/
 * https://developers.google.com/places/web-service/intro
 * Discord or Slack bot
 * https://www.houndify.com/
 

