#include <iostream>
#include <fstream>
#include <set>
#include <vector>

#define INF 9223372036854775807

using namespace std;

set<pair<long long, int>> s;
int n, m;
long long d[222222];
vector<vector<pair<int, long long>>> r;

int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    in >> n >> m;

    for(int i = 0; i < n; ++i) {
        if(i == 0) {
            s.insert(make_pair(0, i));
            d[i] = 0;
        }
        else {
            s.insert(make_pair(INF, i));
            d[i] = INF;
        }
        vector<pair<int, long long>> temp;
        r.push_back(temp);
    }

    for(int i = 0; i < m; ++i) {
        int v, u;
        long long w;
        in >> v >> u >> w;
        --u;
        --v;
        r[v].push_back(make_pair(u, w));
        r[u].push_back(make_pair(v, w));
    }

    while(!s.empty()) {
        pair<long long, int> c = *(s.begin());
        s.erase(s.begin());
        int v = c.second;
        for (pair<int, long long> p : r[v]) {
            int u = p.first;
            long long w = p.second;
            if (d[v] + w < d[u]) {
                if (d[u] != INF) {
                    s.erase(s.find(make_pair(d[u], u)));
                }
                d[u] = d[v] + w;
                s.insert(make_pair(d[u], u));
            }
        }
    }
    out << d[n - 1] << endl;
    return 0;
}
