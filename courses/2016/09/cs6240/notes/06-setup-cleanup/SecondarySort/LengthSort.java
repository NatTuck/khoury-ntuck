package cs6240;

import java.io.IOException;
import java.util.StringTokenizer;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.HashSet;
import java.io.DataInput;
import java.io.DataOutput;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.WritableComparable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.Partitioner;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class LengthSort {
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        if (otherArgs.length < 2) {
            System.err.println("Usage: hadoop jar This.jar <in> [<in>...] <out>");
            System.exit(2);
        }
        Job job = new Job(conf, "word count");
        job.setJarByClass(LengthSort.class);

        job.setMapperClass(SortMapper.class);
        job.setReducerClass(SortReducer.class);
        job.setPartitionerClass(SortPartitioner.class);

        job.setOutputKeyClass(WordAndLength.class);
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

class WordAndLength implements WritableComparable {
    public String word;
    public int length;

    public WordAndLength() {
        // need this for serialization
    }

    public WordAndLength(String word, int length) {
        this.word   = word;
        this.length = length;
    }

    public void write(DataOutput out) throws IOException {
        out.writeUTF(word);
        out.writeInt(length);
    }

    public void readFields(DataInput in) throws IOException {
        this.word   = in.readUTF();
        this.length = in.readInt();
    }

    public int compareTo(Object other) {
        return this.compareTo((WordAndLength) other);
    }

    public int compareTo(WordAndLength other) {
        int dl = this.length - other.length;
        int dw = this.word.compareTo(other.word);

        if (dl == 0) {
            return dw;
        }
        else {
            return dl;
        }
    }

    public int hashCode() {
        return length + word.hashCode();
    }
}

class SortPartitioner extends Partitioner<WordAndLength, IntWritable> {
    @Override
    public int getPartition(WordAndLength key, IntWritable value, int nrt) {
        int S = 12 / nrt;
        int P = key.length / S;

        if (P > nrt - 1) {
            return nrt - 1;
        }
        else {
            return P;
        }
    }
}

class SortMapper extends Mapper<Object, Text, WordAndLength, IntWritable> {
    private final static Pattern nw1 = Pattern.compile("[^'a-zA-Z]");
    private final static Pattern nw2 = Pattern.compile("(^'+|'+$)");

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
        IntWritable one = new IntWritable(1);

        for (String ww : words) {
            context.write(new WordAndLength(ww, ww.length()), one);
        }
    }
}

class SortReducer extends Reducer<WordAndLength,IntWritable,Text,IntWritable> {
    IntWritable one = new IntWritable(1);
    HashSet seen;

    public void setup(Context context) {
        seen = new HashSet<String>();
    }

    public void reduce(WordAndLength key, Iterable<IntWritable> values, Context context
            ) throws IOException, InterruptedException {
        String ww = key.word;

        if (!seen.contains(ww.toString())) {
            context.write(new Text(ww), one);
        }
        seen.add(ww.toString());
    }
}

