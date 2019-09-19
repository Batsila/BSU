import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;

public class Solution {
    public static void main(String[] args) throws IOException {
        Scanner in = new Scanner(new File("input.txt"));
        PrintWriter out = new PrintWriter(new FileWriter("output.txt"));
        long n = in.nextInt();
        for(int i = 0; i < 64; ++i) {
            if((n & 1) == 1) {
                out.println(i);
            }
            n = n >> 1;
        }
        out.flush();
    }
}