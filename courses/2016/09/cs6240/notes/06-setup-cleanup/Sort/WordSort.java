package cs6240;

import java.io.IOException;
import java.util.StringTokenizer;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.HashSet;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.Partitioner;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class WordSort {
  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
    if (otherArgs.length < 2) {
      System.err.println("Usage: hadoop jar This.jar <in> [<in>...] <out>");
      System.exit(2);
    }
    Job job = new Job(conf, "word count");
    job.setJarByClass(WordSort.class);

    job.setMapperClass(SortMapper.class);
    job.setReducerClass(SortReducer.class);
    job.setPartitionerClass(SortPartitioner.class);

    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntWritable.class);

    job.setNumReduceTasks(2);
    
    for (int i = 0; i < otherArgs.length - 1; ++i) {
      FileInputFormat.addInputPath(job, new Path(otherArgs[i]));
    }
    FileOutputFormat.setOutputPath(job,
      new Path(otherArgs[otherArgs.length - 1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}

class SortPartitioner extends Partitioner<Text, IntWritable> {
    @Override
    public int getPartition(Text key, IntWritable value, int nrt) {
        final int A = Character.getNumericValue('a');
        final int Z = Character.getNumericValue('z');
        final int R = Z - A + 1;

        final int F = Character.getNumericValue(key.toString().charAt(0));

        return (F - A) / (R / nrt);
    }
}

class SortMapper extends Mapper<Object, Text, Text, IntWritable> {
    private final static Pattern     nw1 = Pattern.compile("[^'a-zA-Z]");
    private final static Pattern     nw2 = Pattern.compile("(^'+|'+$)");

    private HashSet<String> words;

    public void setup(Context context) {
        words = new HashSet<String>();
    }

    public void map(Object key, Text value, Context context) {
        StringTokenizer itr = new StringTokenizer(value.toString());

        while (itr.hasMoreTokens()) {
            Matcher mm1 = nw1.matcher(itr.nextToken());
            Matcher mm2 = nw2.matcher(mm1.replaceAll("")); 
            String ww = mm2.replaceAll("").toLowerCase();
            
            if (!ww.equals("")) {
                words.add(ww);
            }
        }
    }
   
   public void cleanup(Context context) throws IOException, InterruptedException { 
       Text word = new Text();
       IntWritable one = new IntWritable(1);

       for (String ww : words) {
           word.set(ww);
           context.write(word, one);
       }
   }
}

class SortReducer extends Reducer<Text,IntWritable,Text,IntWritable> {
    IntWritable one = new IntWritable(1);
    HashSet seen;

    public void setup(Context context) {
        seen = new HashSet<String>();
    }

    public void reduce(Text key, Iterable<IntWritable> values, Context context
            ) throws IOException, InterruptedException {
        if (!seen.contains(key.toString())) {
            context.write(key, one);
        }
        seen.add(key.toString());
    }
}

