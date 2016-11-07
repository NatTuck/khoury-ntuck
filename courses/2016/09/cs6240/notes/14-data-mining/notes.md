---
layout: default
---

# Map Reduce: Data Mining

## Homework Questions?

## Data Mining

Discover patterns in large data sets.

The best kind of pattern is a model which we can use to make predictions.

Some common tasks:

 * Clustering - We already talked about k-Means
 * Classification - Is a new email spam?
 * Prediction - Is someone likely to get cancer?
 * Association - What do you do with supermarket loyalty card data?
    Figure out what people are likely to buy based on their purchases, and 
    convice them to buy it from you with ads.

For our end of semester mini-project, we'll be doing a classification / prediction
task, so I'll spend some time going over a common method and showing how it can be
implemented as a parallel algorithm.

There are other methods as well, but I don't have notes on them.

## Random Forests

...

## Data Mining Libraries

[Weka](http://www.cs.waikato.ac.nz/ml/weka/)

 * Integrates well with Map-Reduce programs.
 * Watch for Aggregateable interface.
 * Build model in parallel, combine in reducer.
 * Model can then be serialized for output.
 * Model can then be read in for future MR job that
   uses the model.
 * May need custom input/output formats.
  
[Spark MLlib](http://spark.apache.org/mllib/)

 * Provides machine learning implementations on RDDs or DataFrames.
 * You still need to configure the techinque you pick.





