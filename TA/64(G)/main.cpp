#include <iostream>
#include <fstream>

using namespace std;

int A[111][111];
int n, m;

int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    in >> n;
    in >> m;
    for(int i = 0; i < n; ++i) {
        for(int j = 0; j < n; ++j) {
            A[i][j] = 0;
        }
    }
    for(int i = 0; i < m; ++i) {
        int a, b;
        in >> a;
        in >> b;
        A[a - 1][b - 1] = 1;
        A[b - 1][a - 1] = 1;
    }
    for(int i = 0; i < n; ++i) {
        for(int j = 0; j < n; ++j) {
            out << A[i][j] << " ";
        }
        out << endl;
    }
    return 0;
}
