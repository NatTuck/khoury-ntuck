package path;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.mapreduce.Counter;
import org.apache.hadoop.mapreduce.Counters;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.SequenceFileOutputFormat;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.util.GenericOptionsParser;

public class ShortestPath {
	public static void main(String[] args) throws Exception {
		Configuration conf = new Configuration();
		String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
		conf.set("path-src", otherArgs[0]);
		conf.set("path-dst", otherArgs[1]);

		readInput(conf);

		boolean done = false;
		int ii = 0;
		while (!done) {
			if (ii > 10) {
				throw new Exception("No path in 10 steps.");
			}
			
			done = iterate(conf, ii);
			++ii;
		}
		
		writeOutput(conf, ii);
	}

	public static void readInput(Configuration conf) throws Exception {
		Job job = Job.getInstance(conf, "read input");
		job.setJarByClass(ShortestPath.class);
		job.setMapperClass(InputMapper.class);
		job.setReducerClass(Reducer.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(NodeOrEdge.class);
		job.setOutputFormatClass(SequenceFileOutputFormat.class);

		FileSystem fs = FileSystem.get(conf);
        fs.delete(new Path("graph0"), true);
        
		FileInputFormat.addInputPath(job, new Path("graph.tsv.bz2"));
		FileOutputFormat.setOutputPath(job, new Path("graph0"));

		boolean ok = job.waitForCompletion(true);
		if (!ok) {
			throw new Exception("Job failed");
		}
	}

	public static boolean iterate(Configuration conf, int ii) throws Exception {
		Job job = Job.getInstance(conf, "shortest path iteration");
		job.setJarByClass(ShortestPath.class);
		job.setMapperClass(PathMapper.class);
		job.setReducerClass(PathReducer.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(NodeOrEdge.class);
		job.setInputFormatClass(SequenceFileInputFormat.class);
		job.setOutputFormatClass(SequenceFileOutputFormat.class);
		
		FileSystem fs = FileSystem.get(conf);
        fs.delete(new Path("graph" + (ii + 1)), true);
        
		FileInputFormat.addInputPath(job, new Path("graph" + ii));
		FileOutputFormat.setOutputPath(job, new Path("graph" + (ii + 1)));

		boolean ok = job.waitForCompletion(true);
		if (!ok) {
			throw new Exception("Job failed");
		}

		fs.delete(new Path("graph" + ii), true);

		Counters cs = job.getCounters();
		Counter done = cs.findCounter("path", "done");
		return done.getValue() > 0;
	}
	
	public static void writeOutput(Configuration conf, int ii) {
		
	}
}
