---
layout: default
---

## Two ways to maintain state:

### Session Cookies

 - Stores data in the user's browser.
 - Relies on user to send it back:
   - Encrypted with secret-key-base; prod.secret.exs matters now.
   - User can delete cookies, may do so randomly.

Functionality provided by plug.

 - Need :plug fetch_session in router.
 - put_session(conn, key, value)
 - get_session(conn, key)

### Web App State

 - Spawn an agent.
 - Have it remember stuff.



