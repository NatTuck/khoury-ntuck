---
layout: default
---

Thursday:  	EL 312 	11:45am - 1:25pm

Friday:     WVG 102	3:25pm - 5:05pm


# HTML & CSS

## HTML2 document:

```
<html>
  <head>
    <title>Welcome to HTML</title>
  </head>
  <body>
    <p>This is a <i>very</i> simple web page.
  </body>
</html>
```

 - HTML is a format that allows us to describe a structured document.
 - Encodes a tree of elements.
 - Each element is encoded by a tag. Different tags have different semantic meanings.
 - HTML alone doesn't fully specify how a document is rendered - rendering
   can be altered by CSS.
 - For rendering, we can think of each element as a rectangular portion of
   the web page. (Pull up dev tools, highlight the "p" vs the "i" tags.

Broad bucketing of tags:

 - Non-displayed elements (metadata, broad structure): html, head, title, body
 - Block elements: p   (Text goes in a block)
 - Inline elements: i  (Inline elements go in text and mark up parts of it)
 
## HTML5 document:

page.html:

```
<!doctype html>
<!-- simple doctype selects HTML 5 -->
<html lang="en">
  <!--
       The lang attribute is important for font selection, especially
       for non-European languages. 
  -->
  <head>
    <meta charset="utf-8">
    <!-- First line of head is meta charset="utf-8". This prevents annoying bugs later. -->

    <title>Hello, Web</title>

    <link rel="stylesheet" href="style.css">
    <!--
         external styles go in the head
         styles should be external by default, leaving HTML for structure.
    -->
  </head>
  <body>
    <h1>Hello, Web</h1>

    <p>This is a simple web page.</p>

    <p class="red-text">This is red.</p>

    <p id="data-dst">&nbsp;</p>

    <div id="the-box">
      <p>In the box p1</p>
      <p>In the box p2
    </div>
  </body>
</html>
```

style.css:

```
h1 { text-decoration: underline }

.red-text { color: red }

#the-box {
    border: thin solid green;
    width: 40%;
    padding: 1rem;
}
```

## Tour of HTML Tags

Once you have the basic structure of your HTML5 document, most of the work
happens in the body of the document, where the displayed content of the page
lives.

The Generic Tags:

 - div - A block element with no special semantic meaning. This gives you a box to put stuff in.
 - span - An inline element with no special semantic meaning. This lets you
   differentiate one piece of text in a larger block. This is useful for styles or scripts.

Major functionality tags:

 - img - Lets you embed an image.
 - a - Gives you a clickable link, usually to another page.

Text document tags:

 - p - Indicates a paragraph of text.
 - em - Emphasis
 - sup - Superscript
 - blockquote - An indented paragraph, for quoted text
 - ul / li - Unordered (bulleted) list
 - ol / li - Ordered (numbered) list

Tables:

```
<table>
  <tr>
    <th>First Column</th>
    <th>Second Column</th>
    <th>Third Column</th>
  </tr>
  <tr>
    <td>giraffe</td>
    <td>giraffe</td>
    <td>giraffe</td>
  </tr>
  <tr>
    <td>giraffe</td>
    <td>giraffe</td>
    <td>giraffe</td>
  </tr>
</table>
```

Forms:

 - See form.html
   - Add CSS formatting
   - Note that "display: inline-block" gives us a box embedded in text.
 - Action is the path to be sumitted to.
 - Default method is GET, which causes form to be submitted as query string (?key=value&key2=val2)
 - Other choice (normally correct) is POST; data doesn't show up in address bar.
 - Semantics: GET is for queries that don't change anything, POST may mutate state
   - Browsers may pre-fetch GET links and even pre-submit GET forms to cache the result and speed
     up browsing.
 - Wonk the button: show new address & query string.

## CSS

CSS changes the rendering of an HTML document, allowing "style" information to be
specified separately from document content and structure.

CSS is made up of rules. Each rule has three key elements:

 - A selector (which element(s) does this apply to?)
 - A property name (what property are we setting?)
 - A property value (what are we setting it to?)

Simplest example is inline styles:

```
  <p style="color: blue">Text</p>
```

 - In this case, there's no selector. The rule applies to this tag.
 - Property name is "color", this sets the text color.
 - Property value is "blue", this text will be blue.
 - Generally using inline styles is bad form; style rules should be separate from
   the content.

Style tags:

 - Like in the form example.
 
External style sheets:

 - Like in the initial example.
 - This is generally the preferred strategy:
   - Easier to maintain.
   - Faster page loads (external style sheet can be cached, apply across multiple pages)

General syntax for non-inline CSS:

 - selector { name1: value1; name2: value2; ...}
 - Three common selector forms:
   - input - Tag name, no putuation, applies to all instances of that tag.
   - .foo  - Class name. Applies to all tags with class="foo"
   - #bar  - Tag ID. Applies to the one tag with id="bar". Duplicate IDs are invalid HTML.
 - Add examples with class / id selectors.

Floats and clearfix.

 - see floats.html

Multi-column layouts.

 - see threecol.html


