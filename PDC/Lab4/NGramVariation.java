import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;

import org.apache.commons.compress.utils.Charsets;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;


public class NGramVariation {
    public static class NGramMapper extends Mapper<Object, Text, Text, Text> {
        private Text gram = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            String word = value.toString();
            String[] parts = word.split("\\s+");
            gram.set(parts[0] + " " + parts[1] + " " + parts[2] + " " + parts[3] + " " + parts[4]);
            int frequency = Integer.parseInt(parts[6]);
            context.write(gram, new Text(String.valueOf(frequency)));
        }
    }

    public static class NGramReducer extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context context)
                throws IOException, InterruptedException {
            double average = 0.;
            long count = 0;
            List<Integer> frequencies = new ArrayList<Integer>();

            for (Text value : values) {
                String val = value.toString();
                int current = Integer.parseInt(val);
                frequencies.add(current);
                average += current * 1.;
                count++;
            }

            average = average * 1. / count;

            double variance = 0.;
            for(int frequency : frequencies) {
                variance += (frequency - average) * (frequency - average);
            }
            variance /= count;

            context.write(new Text(key), new Text(" , " + String.valueOf(Math.round(variance * 1000.0) / 1000.0) + " , " + frequencies.toString()));
        }
    }

    public static void calculateTopTwenty(Path path, JobConf conf) throws IOException {
        Map<Double, String> topTwentyMap = new TreeMap<Double, String>(Collections.reverseOrder());
        StringBuilder topTwenty = new StringBuilder();
        topTwenty.append("\n");

        FileSystem fs = FileSystem.get(conf);
        Path file = new Path(path, "part-r-00000");
        if (!fs.exists(file)) {
            throw new IOException("Output not found!");
        }
        BufferedReader br = null;

        try {
            br = new BufferedReader(new InputStreamReader(fs.open(file), Charsets.UTF_8));
            String line;
            String ngram;
            double variance;

            while ((line = br.readLine()) != null) {
                String[] tokens  = line.split("\\s+");
                ngram = tokens[0] +  " " + tokens[1] + " " +  tokens[2] + " " +  tokens[3] + " " +  tokens[4];
                variance = Double.parseDouble(tokens[6]);
                topTwentyMap.put(variance, ngram);
            }

            int twenty = 0;
            Iterator<Map.Entry<Double, String>> entries = topTwentyMap.entrySet().iterator();
            while (twenty != 21 && entries.hasNext())
            {
                twenty++;
                Map.Entry<Double, String> next = entries.next();
                topTwenty.append(String.valueOf(twenty));
                topTwenty.append(". Ngram : ");
                topTwenty.append(next.getValue());
                topTwenty.append(" Variance : ");
                topTwenty.append(String.valueOf(next.getKey()));
                topTwenty.append("\n");
            }
            System.out.println("The top is: " + topTwenty);

        } finally {
            if (br != null) {
                br.close();
            }
        }
    }

    public static void main(String[] args) throws Exception {
        JobConf conf = new JobConf(NGramVariation.class);
        Job job = Job.getInstance(conf, "ngram variation");
        job.setJarByClass(NGramVariation.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        job.setMapperClass(NGramMapper.class);
       // job.setCombinerClass(NGramReducer.class);
        job.setReducerClass(NGramReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);
        boolean completed = job.waitForCompletion(true);
        calculateTopTwenty(new Path(args[1]), conf);
        System.exit(completed ? 0 : 1);
    }
}