#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <iomanip>
using namespace std;

const int MAXN = 111111;
const int INF =  1111111111;
int a[MAXN], dp[MAXN];
int f1[MAXN], f2[MAXN];
int n;

int bs1(int key) {
    int l = -1;
    int r = n;
    int m;
    while(l < r - 1) {
        m = (l + r) / 2;
        if (dp[m] < key)
            l = m;
        else
            r = m;
    }
    return r;
}

int bs2(int key) {
    int l = -1;
    int r = n;
    int m;
    while(l < r - 1) {
        m = (l + r) / 2;
        if (dp[m] > key)
            l = m;
        else
            r = m;
    }
    return r;
}

int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    in >> n;
    for(int i = 0; i < n; ++i) {
        in >> a[i];
    }
    dp[0] = -INF;
    for(int i = 1; i <= n; ++i) {
        dp[i] = INF;
    }


    for(int i = 0; i < n; ++i) {
        int j = bs1(a[i]);
        if(i == 0)
            f1[0] = 1;
        else
            if(dp[j] == INF)
                f1[i] = f1[i - 1] + 1;
            else
                f1[i] = f1[i - 1];
        dp[j] = a[i];
    }
    dp[n - 1] = INF;
    for(int i = 0; i < n - 1; ++i) {
        dp[i] = -INF;
    }
    for(int i = n - 1; i >= 0; --i) {
        int j = bs2(a[i]);
        if(i == n - 1)
            f2[n - 1] = 1;
        else
            if(dp[j] == -INF)
                f2[i] = f2[i + 1] + 1;
            else
                f2[i] = f2[i + 1];
        dp[j] = a[i];
    }
    int ans = 0;
    for(int i = 0; i < n - 1; ++i)
        ans = max(ans, f1[i] + f2[i + 1]);
    if(n == 1)
        out << 1 << endl;
    else
        out << ans << endl;
    return 0;
}
