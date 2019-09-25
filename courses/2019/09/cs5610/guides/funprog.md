---
layout: default
---

# Functional Programming Review

Basic functional programming technique in Elixir and JavaScript.

 - Functional concepts
 - Simple data
 - Structs
 - Lists
 - Maps
 
# Other Resources

[Medium post on Functional Programming in JS](https://medium.com/the-renaissance-developer/concepts-of-functional-programming-in-javascript-6bc84220d2aa)

# Intro

In Web Development we're using a functional language (Elixir) and some
JavaScript libraries that expect us to manipulate data in a functional style
(React, Redux).

This document provides some simple examples of what that looks like.

# Functional Concepts

Functional programming is about values, and functions that create
new values based on existing ones.

A good example of this is comparing the default "sort" methods in Python and
Ruby.

```
# Python
>>> xs = [1,4,3,2]
>>> xs.sort()
>>> xs
[1, 2, 3, 4]
```

This is common to imperative style proramming. The sort method mutates the
array, sorting the elements in place. Once the sort method has been called, the
original unsorted array value is no longer available.

```
# Ruby
irb> xs = [1,4,3,2]
=> [1, 4, 3, 2]
irb> ys = xs.sort
=> [1, 2, 3, 4]
irb> xs
=> [1, 4, 3, 2]
irb> ys
=> [1, 2, 3, 4]
```

This variant is *required* in functional style programming. The sort method
creates a new array containing the same element values as the original in a
different order. The original unsorted array value is unchanged.

Because data isn't mutated in place, various techniques can be used that rely on
data values not changing. This can be used for performance in some cases, but
primarily serves as a way to make programs easier to reason about.

Immutable data, either as a language feature or as a design pattern, allows for
a couple of really useful optimizations:

 - Reference comparision: A changed object will always have a new memory
   address, so changes can be detected by the Java (==) operator rather than
   by doing a structure traversal for value equality.
 - [Structural
   sharing](https://en.wikipedia.org/wiki/Persistent_data_structure): Two
   similar values can be stored by using the same memory for the shared portion
   of the structure.

Immutable data also has an amazing feature in the presence of concurrency (e.g.
threads) - it completely prevents data races. A data race requires that data be
both shared and modified. This can allow for some styles of programming to
completely avoid locks while still gaining the benefits of concurrent (and
parallel) execution.

To generalize, mutation is just a specific example of a more general concept
that functional style programs try to avoid / isolate: Side effects. A function
without side effects is called a "pure" function - for a given set of input
values it will always produce the same output value. This lets you do some neat
tricks:
 
 - Because pure functions always produce the same output for a given input, it's
   safe to cache their outputs. This can be useful to avoid repeating expensive
   computations.
 - Because pure functions have no side effects, it's safe to automatically
   re-run them multiple times. This can be used for transactions - if a
   transaction defined as a pure function fails, it can safely be re-run
   either on the same inputs or on newer input values.
 - Pure functions are really easy to test. If a test shows they produce the
   right output for a given input, you can be sure that's always true.

# Simple Data

Most languages have a concept of "primitive" data types that are innately
treated as immutable values. Numbers are the simplest example: The number 4
always has the value 4. You can assign a different number to a variable or
object field, but you can't change the value itself.

Java handles strings this way. You can't mutate a Java string, instead the
StringBuffer class exists for cases where in-place string manipulation is
desired. In a functional style, you don't get StringBuffer.

Writing functions on simple data values works the same in a functional style as
in any language.

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


# Structs

Here "struct" is a general term for an object with a fixed set of fields. This
is a built-in concept in Elixir, and a design pattern in JavaScript.

In Java, the idea of an immutable struct is referred to as a
"[value object](https://en.wikipedia.org/wiki/Value_object)".

For example, we might have a type of object we call a "person", with three
fields:

 - Name : String
 - dob  : Date (date of birth)
 - job  : String

Name and birth date don't change much, but sometimes occupation changes. To
hande this, we produce a new struct with the same fields:

JavaScript:

```
// In JS, a struct is just an object where we've decided on a fixed
// set of fields.

function set_job(person, job) {
  return {
    name: person.name,
    dob: person.dob,
    job: job,
  };
}

// Shorthand:
function set_job1(person, job) {
  return {...person, job: job};
}
```

Elixir:

```
defmodule Person do
  # Set defaults
  defstruct name: "Bob", dob: ~D[2000-01-02], job: "Fisherman"

  def set_job(person, job) do
    %Job{
       name: person.name,
       dob: person.dob,
       job: job,
    }
  end

  # Shorthand:
  def set_job1(person, job) do
    %{ person | job: job }
  end
end

# We can also just use a Map with a fixed set of fields, like in JS.
```

In Elixir, an common alternative for structs is the Tuple. It has multiple
fields distingushed by position and is convenient to use with pattern matching.

```
# Compute the distance between two points
def distance({x0, y0}, {x1, y1}) do
  dx = x1 - x0
  dy = y1 - y0
  :math.sqrt(dx*dx + dy*dy)
end

iex> origin = {0, 0}
iex> dest = {10, 0}
iex> distance(origin, dest)
10
```


# Arrays and Lists

We need a data type to represent sequences of values. Generally each value in
a sequence is of the same type (e.g. "List of Number", "List of Person", "List
of List of Number").

The native functional sequence structure is the linked list because it allows
structural sharing, but in JavaScript the default sequence type is the variable
length array (C++ "vector", Java "ArrayList").

The standard pattern for traversing an array is a loop, while the standard
pattern for traversing a list is recursion.

Arrays are innately constructed by mutation, so to program with them in a
functional style we want to hide that mutation by doing it only locally within
the fuction constructing the array. The efficient way to add single items to an
array is with "push".

We can completely hide this mutation by using standard higher order sequence
processing functions like "map", "reduce", and "filter".

## Reverse a sequence of numbers.

JavaScript:

```
function reverse(xs) {
    // Result is a new array.
    // Mutation only occurs on an object in the function where that
    // object is constructed. No references to the partially constructed
    // object are allowed to leak.
    let ys = [];
    for (let ii = xs.length - 1; ii >= 0; --ii) {
      ys.push(xs[ii]);
    }
    return ys;
}
```

Elixir:

```
# This is inefficient, using O(n^2) time and O(n) extra stack space.
def reverse1(xs) do
  if xs == [] do
    [] 
  else
    reverse(tl(xs)) ++ [hd(xs)]
  end
end

# The same with pattern matching.
def reverse2([]), do: []
def reverse2([x|xs]), do: reverse(xs) ++ [x]

# This is linear time and no extra space, using an accumulator.
# Algorithmically equivilent to the JS code above.
def reverse3(xs), do: reverse3(xs, [])
def reverse3([], ys), do: ys
def reverse3([x|xs], ys), do: reverse(xs, [y|ys])

# The standard list function "reduce" generalizes the
# above accumulator pattern.
def reverse4(xs) do
  Enum.reduce xs, [], fn (x, ys) ->
    [x | ys] 
  end
end

# One line, "&(&1)" is shorthand for "fn (x) -> x end"
def reverse5(xs), do: Enum.reduce xs, [], &([&1 | &2])
```

## Given a sequence of names, generate a sequence of "Hello, {name}"

JavaScript:

```
function hello_all(names) {
  let ys = []
  for (name of names) {
    ys.push("Hello, " + name) 
  }
  return ys;
}

# Use the standard "map" method and template strings
function hello_all2(names) {
  return names.map(function (name) {
    return `Hello, ${name}`
  });
}

# Using the lodash helper, usually because you forgot about built-in
# name method on array.
let hello_all3 = (names) => _.map(names, (name) => ("Hello, " + name));
```

Elixir:

```
def hello_all([]), do: []
def hello_all([name|rest]) do
  hello = "Hello, #{name}"
  [hello | hello_all(rest)]
end

def hello_all1(names) do
  Enum.map names, fn (name) ->
    "Hello, #{name}" 
  end
end
```

## Find all the people in a list who were born before the year 2000.

JavaScript:

```
function find_old(people) {
  let cutoff = new Date("2000-01-01");
  let ys = [];
  for (person of people) {
    if (person.dob < cutoff) {
      ys.push(person); 
    }
  }
  return ys;
}

function find_old1(people) {
  let cutoff = new Date("2000-01-01");
  return people.filter((person) => person.dob < cutoff));
}
```

Elixir:

```
def find_old([]), do: []
def find_old([person | rest]) do
  cutoff = ~D[2000-01-01]
  if Date.compare(person.dob, cutoff) == :lt do
    [person | find_old(rest)] 
  else
    find_old(rest) 
  end
end

def find_old1(people) do
  cutoff = ~D[2000-01-01]
  Enum.filter people, fn (person) ->
    Date.compare(person.dob, cutoff) == :lt 
  end
end
```

# Maps

In addition to sequences, the other super-common data structure is the key-value
map. In imperative languages, this tends to be a hash table (HashMap in Java),
while in functional languages it tends to be a tree to take advantage of
structural sharing.

In JavaScript, the standard "object" type is frequently used as a map, but it
has the constraint that strings must be keys. Recent versions of JavaScript have
a dedicated Map type (make one with "new Map") that properly handles non-string
keys.

Elixir also has two map types. It has the standard map type constructed with "%{
... }", and also uses association lists, or lists of key-value tuples.
Association lists are less efficient for random access when they get big, but
are extremely useful as an intermediate structure for constructing maps from
lists.

Like with arrays, JavaScript objects and maps are innately constructed by
mutation. The same pattern as with arrays should be followed: limit mutation to
the function that constructs the object.

# Lodash

Some of the methods on arrays and maps in JavaScript follow the functional style
(e.g. .map and .filter), while others mutate their inputs. Lodash provides a set
of common functions that consistently produce new values rather than mutating.

# Immutable collections in JavaScript

Following a functional style in JavaScript works great when using the built in
data types with small collections, as long as you're consistent about following
the no-mutation constraint.

For larger data, or to avoid mutating collections by mistake, it can be useful
to have proper immutable collection types in JavaScript. These are available in
a library called [immutable.js](https://github.com/immutable-js/immutable-js).

