+++
title = "Old Project Ideas"
draft = true
+++

## Storm Chat

  -  App monitors the NWS alerts feed at https://alerts.weather.gov/
  -  Each alert creates a chatroom / realtime comment feed.
    - Chat messages are stored in the DB forever.
  -  Users can chat about the alert in the chatroom.
  -  Users can sign up for emails when new alerts in their area happen.

## Next Bus Tracker

 - Users can sign up to track bus info at specific stops.
 - Use HTML5 geolocation to determine the bus stop the user is at.
 - App polls the MBTA realtime bus data
 - App interpolates bus arrival prediction
 - App shows time to next bus, using websockets to push latest predictions and
   JS to do further interpolation client-side.

## Cryptocurrency price monitoring.

 - App connects to exchange APIs (e.g. Coinbase, Kraken) and polls
   cryptocurrency prices.
 - Users select some cryptocurrencies to monitor.
 - App shows monitored cryptocurrency prices for all exchanges - websockets push
   current prices to browser in real time.
 - Users can create alerts to get emails when a cryptocurrency crosses a price
   threshold or there's an arbitrage opportunity.

## Capture the Campus Game

 - Use the Google Maps API to find the location of buildings at Northeastern
 - Use HTML5 geolocation to track player position
 - Games are between equal sized teams.
 - To capture a building, you need to stand next to it, press "capture", and
   wait for one minute.
 - If you come near a building being captured by your opponent, you can press a
   KO button to knock them out.
 - If you've been KO'ed, you need to walk over to Snell Library and press
   "Recover" to fix it.
 - First team to capture CCIS, COE, College of Science, and International
   Village wins.
 - Locations are sent to server and action buttons are enabled via websockets.
 - Users register accounts and join teams.
 - User win/loss record is stored in the database and balance teams are
   auto-generated.

## SMS Client

 - Use the Twilio API to send and recieve SMS messages.
 - Use websockets to push incoming messages to the browser.
 - Store message history in the DB.
