#include <iostream>
#include <fstream>
#include <map>
#include <algorithm>
using namespace std;

const int MAXN = 555;
const int INF = 1234567;
int dp[MAXN][MAXN];
map<int, int> a;
int n;

int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    in >> n;
    for(int i = 1; i <= n; ++i) {
        int temp;
        in >> temp;
        a.insert(make_pair(temp, i));
    }
    for(int i = 1; i <= n; ++i) {
        for(int j = i; j > 0; --j) {
            if(i == j) {
                dp[i][j] = 0;
            }
            else {
                int d = INF;
                for(int k = 0; k < i - j; ++k) {
                    int temp = dp[i - 1 - k][j] + dp[i][i - k] + abs(a.find(i - 1 - k)->second - a.find(i)->second);
                    d = min(d, temp);
                }
                dp[i][j] = d;

            }
        }
    }

    out << dp[n][1] << endl;
    return 0;
}
