#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

vector<vector<int>> v;
int n, m;

int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    in >> n;
    in >> m;
    for(int i = 0; i < n; ++i) {
        vector<int> temp;
        v.push_back(temp);
    }
    for(int i = 0; i < m; ++i) {
        int a, b;
        in >> a;
        in >> b;
        v[a - 1].push_back(b);
        v[b - 1].push_back(a);
    }
    for(int i = 0; i < n; ++i) {
        out << v[i].size();
        for(int j = 0; j < v[i].size(); ++j) {
            out << " " << v[i][j];
        }
        out << endl;
    }
    return 0;
}
