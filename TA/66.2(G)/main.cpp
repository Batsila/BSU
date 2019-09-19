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
    for(int i = 0; i < n; ++i) {
        int a = i + 1;
        int b;
        for(int j = 0; j < n; ++j) {
            in >> b;
            if(b == 1) {
                P[j] = a;
            }
        }

    }
    for(int i = 0; i < n - 1; ++i) {
        out << P[i] << " ";
    }
    out << P[n - 1];
    return 0;
}
