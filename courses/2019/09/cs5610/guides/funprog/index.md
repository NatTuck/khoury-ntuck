
# Functional Programming Review

Basic functional programming technique in Elixir and JavaScript.

 - Functional concepts
 - Simple data
 - Structs
 - Lists
 - Maps

# Functional Concepts

Functional programming is about values, and functions that create
new values based on existing ones.

A good example of how this is distinct from imperative programming is sorting
functions:

```
  # In-place sort, common in imperative style:
  xs = get_a_list()
  sort(xs)
  # Our list in 'xs' is now sorted
  # There's no way to access the old, unsorted list.
  
  # Out-of-place sort, required in functional style:
  xs = get_a_list()
  ys = sort(xs)
  # Our list in 'ys' is now sorted
  # The origional unsorted 'xs' list is still available.
```

Because data isn't mutated in place, various techniques can be used that rely on
data values not changing. This can be used for performance in some cases, but
primarily serves as a way to make programs easier to reason about.

# Simple Data

JavaScript:

```
  function square(a) {
    return a * a; 
  }
  
  function pluralize(word) {
   return word + "s"; 
  }
```

Elixir:

```
  def square(a) do
    a * a 
  end
  
  function pluralize(word) do
    word <> "s" 
  end
```




