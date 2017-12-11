---
layout: default
---

## First Thing

Homework questions?

## Adding Passwords

### Concept

 - We want to authenticate users.
 - At registration, they select a password.
 - To log in, they enter their password and we need
   to verify that it's the same one.

### Online Attacks

 - Try to log in to the application with a password.
 - When that fails, try again with a different one.
 - Repeat

Securing against online attacks:

 - Trying the 1000 most common password takes 1000 requests.
 - Limiting attempt rate solves the problem.
 - Even relitively high limits: 25 attempts, resets every hour,
   prevents trying all 1000 in less than a day.
 - If add a ban on very short and common passwords, this problem
   is basically solved.

### Implementation 

Bad Idea: Store passwords in database.

Advantages:
 
 - Simple
 - Can tell people forgotten passwords.
 
Disadvantages:

 - Site admin has access to all user passwords.
 - Anyone who gets a copy of the database gets
   a copy of the passwords.


People re-use passwords, so a leak of passwords is a significant
security issue even for *other* applications.


Good Idea: Store cryptographic hash of password in DB

Advantages:

 - Access to the DB doesn't expose passwords.
 
Disadvantages:

 - Can't remind user of forgotten password. Can only reset.
 - Easy to get wrong.
 
 
Cryptographic hashing algorithms:

 - Transform arbitrary input into 128 to 512 bit "hash".
 - One way: No way to get from the hash to the input.
 - No collisions: Can't find two inputs that hash to the same value.
 - Fast: Can calculate hash quickly.
 
### Offline Attacks

 - Brute force attack: Try all possible passwords up to some length.
   - There are less than a billion 6 character passwords.
 - Dictionary attack: Try words and common passwords.
   - Lots of people use the most common 100,000 passwords.
 - Dictionary + pattern attacks: Most passwords are a word, permuted.
   - pa55w0rd
 - Use a GPU for the brute force attempt. Can do hundreds of millions
   of hashes per second with standard cryptographic hashes.

Bad idea:

 - Require a letter, a number, and a symbol.
   - Loses to pattern attacks.

Good ideas:

 - Minimum password length. Probably at least 8.
 - Ban common passwords.
 - Make the hash function slower. If an attacker can try 10/second rather than 10^8/second,
   that's much more secure.

### Password Hashing Algorithms

 - Same properties as normal cryptographic hashing algos.
 - Except they're slow instead of fast.
 
Examples:

 - PBKDF2 (the NIST standard)
 - bcrypt (the most popular one)
 - scrypt (slower on GPUs)
 - argon2 (latest and greatest, slower on GPUs)

Elixir library for password hashing:

 - https://github.com/riverrun/comeonin


### Rainbow Tables and Salts

You generally don't want to crack one password hash, you've got a bunch of password
hashes and want to crack *any* of them.

This means pre-computing the hashes for your password dictionary saves a bunch of time,
especially if a good password hashing algorithm is being used.

To defend against this attack, we add a "salt" to a password hash. We generate a random
string and concatenate it with the password before hashing. Then we store the salt with
the password hash so we can repeat at authentication time.

This pretty effectively ruins the pre-computation plan, even with relatively small salts.
A 32-bit salt increases the size of hash database required by a factor of 4 billion.


## Adding Passwords to NuMart

### Registration

Add the comeonin module

```
    # deps in mix.exs
    {:comeonin, "~> 4.0"},
    {:argon2_elixir, "~> 1.2"},
    
    # now mix deps.get
```

Add some fields to the user table.

```
mix ecto.gen.migration add_passwords
```

```
  # In the new migration
  def change do
    alter table("users") do
      add :password_hash, :string
      add :pw_tries, :integer, null: false, default: 0
      add :pw_last_try, :utc_datetime
    end
  end
```

Update accounts/user.ex, see attached.

```
  <!-- users/form.eex -->
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

```
  <!-- layout/app.html.eex -->
  <input type="password" placeholder="password"
         class="form-control" name="password">
```

Let's register a user.

### Authentication

```
  # In session_controller.ex

  # TODO: Move to user.ex
  def get_and_auth_user(email, password) do
    user = Accounts.get_user_by_email(email)
    case Comeonin.Argon2.check_pass(user, password) do
      {:ok, user} -> user
      _else       -> nil
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    user = get_and_auth_user(email, password)
    
  # ...
      |> put_flash(:error, "Bad email/password")
  
```

Let's try this out.


Strategy for limiting login attempts:

 * Check if last attempt is within the last hour.
   * If so, check if attempts > 10.
     * If so, block the login.
   * If not, zero out attempts.
 * Set last login to now.
 * Increment attempts.
 * Save user.
 
```
  # TODO: Move to user.ex
  def update_tries(throttle, prev) do
    if throttle do
      prev + 1
    else
      1
    end
  end

  def throttle_attempts(user) do
    y2k = DateTime.from_naive!(~N[2000-01-01 00:00:00], "Etc/UTC")
    prv = DateTime.to_unix(user.pw_last_try || y2k)
    now = DateTime.to_unix(DateTime.utc_now())
    thr = (now - prv) < 3600

    if (thr && user.pw_tries > 5) do
      nil
    else
      changes = %{
          pw_tries: update_tries(thr, user.pw_tries),
          pw_last_try: DateTime.utc_now(),
      }
      IO.inspect(user)
      {:ok, user} = Ecto.Changeset.cast(user, changes, [:pw_tries, :pw_last_try])
      |> NuMart.Repo.update
      user
    end
  end
```

