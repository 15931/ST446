import java.io.IOException;
import java.util.Scanner;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class AuthorsJob {

  public static class AuthorsMapper extends
          Mapper<Object, Text, Text, IntWritable> {

        private final static IntWritable one = new IntWritable(1);
        private Text author = new Text();

        public void map(Object key, Text value, Context context)
                throws IOException, InterruptedException {

          /* Open a Java scanner object to parse the line */
          Scanner line = new Scanner(value.toString());
          line.useDelimiter("\t");
          author.set(line.next());
          context.write(author, one);
        }
  }

  public static class CountReducer extends
          Reducer<Text, IntWritable, Text, IntWritable> {
        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values,
                        Context context)
                throws IOException, InterruptedException {

          /* Iterate on the list to compute the count */
          int count = 0;
          for (IntWritable val : values) {
                count += val.get();
          }
          result.set(count);
          context.write(key, result);
        }
  }

  public static void main(String[] args) throws Exception {

	/*
	 * Load the Haddop configuration. IMPORTANT: the
	 * $HADOOP_HOME/conf directory must be in the CLASSPATH
	 */
	Configuration conf = new Configuration();

	/* We expect two arguments */

	if (args.length != 2) {
	  System.err.println("Usage: AuthorsJob <in> <out>");
	  System.exit(2);
	}

	/* Allright, define and submit the job */
	Job job = new Job(conf, "Authors count");

  // Simon -- This is necessary to run it on the GCP hadoop cluster.
  job.setJarByClass(AuthorsJob.class);

	/* Define the Mapper and the Reducer */
	job.setMapperClass(AuthorsMapper.class);
	job.setReducerClass(CountReducer.class);

	/* Define the output type */
	job.setOutputKeyClass(Text.class);
	job.setOutputValueClass(IntWritable.class);

	/* Set the input and the output */
	FileInputFormat.addInputPath(job, new Path(args[0]));
	FileOutputFormat.setOutputPath(job, new Path(args[1]));

	/* Do it! */
	System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}
