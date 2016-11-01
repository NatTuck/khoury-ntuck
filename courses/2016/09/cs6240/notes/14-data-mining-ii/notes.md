---
layout: default
---

# Map Reduce: Joins and also Spark

## Homework Questions?

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





