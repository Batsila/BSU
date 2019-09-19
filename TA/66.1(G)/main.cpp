#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

int P[111111];
int n;

int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    in >> n;
    for(int i = 0; i < n; ++i) {
        P[i] = 0;
    }
    for(int i = 0; i < n - 1; ++i) {
        int a, b;
        in >> a;
        in >> b;
        P[b - 1] = a;
    }
    for(int i = 0; i < n - 1; ++i) {
        out << P[i] << " ";
    }
    out << P[n - 1];
    return 0;
}
