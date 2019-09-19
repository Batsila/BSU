#include <iostream>
#include <fstream>
#include <algorithm>
using namespace std;

const int MAXN = 111111;
const int INF =  1111111111;
int a[MAXN], dp[MAXN][2];
int n;


int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    in >> n;
    for(int i = 1; i <= n; ++i) {
        in >> a[i];
    }
    bool ok = true;
    for(int i = 1; i <= n / 2; ++i) {
        if(a[i] > a[2 * i]) {
            ok = false;
            break;
        }
        if(2 * i + 1 > n) {
            break;
        }
        else {
            if(a[i] > a[2 * i + 1]) {
                ok = false;
                break;
            }
        }
    }
    if(ok) {
        out << "Yes" << endl;
    }
    else {
        out << "No" << endl;
    }

    return 0;
}
