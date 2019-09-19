#include <fstream>

using namespace std;

ifstream in("input.txt");
ofstream out("output.txt", ios_base::trunc);

int dp[1000][1000];
int n[1000], m[1000];

int main()
{
    int N;
    in >> N;
    for(int i = 0; i < N; ++i) {
        in >> n[i];
        in >> m[i];
    }
    for(int i = 0; i < N; ++i) {
        dp[i][i] = 0;
        if (i != N - 1) {
            dp[i][i + 1] = n[i] * m[i] * m[i + 1];
        }
    }
    for (int i = N - 3; i >= 0; --i) {
        for (int j = i + 2; j < N; ++j) {
            int minimum = 2147483647;
            for (int k = i; k < j; ++k) {
                int temp = dp[i][k] + dp[k + 1][j] + n[i] * m[k] * m[j];
                if(temp < minimum) {
                    minimum = temp;
                }
            }
            dp[i][j] = minimum;
        }
    }
    out << dp[0][N - 1] << endl;
    return 0;
}
