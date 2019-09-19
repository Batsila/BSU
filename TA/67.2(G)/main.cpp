#include <iostream>
#include <fstream>

using namespace std;

int g[111][111];
bool u[111];
int met[111];
int n;
int k = 0;

void dfs (int v) {
	u[v] = true;
	met[v] = ++k;
	for(int i = 0; i < n; ++i) {
        if(g[v][i] == 1 && !u[i]) {
            dfs(i);
        }
	}
}

int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    in >> n;
    for(int i = 0; i < n; ++i) {
        u[i] = false;
        for(int j = 0; j < n; ++j) {
            in >> g[i][j];
        }
    }

    for(int i = 0; i < n; ++i) {
        if(!u[i]) {
            dfs(i);
        }
    }

    for(int i = 0; i < n; ++i) {
        out << met[i] << " ";
    }
    return 0;
}
