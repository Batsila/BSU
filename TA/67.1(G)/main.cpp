#include <iostream>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

int met[111];
bool u[111];
int a[111][111];
int n;
queue<int> q;
int k = 0;

void bfs(int s) {
    q.push(s);
    u[s] = true;
    while(!q.empty()) {
        int c = q.front();
        q.pop();
        met[c] = ++k;
        for(int i = 0; i < n; ++i) {
            if(a[c][i] == 1) {
                if(!u[i]) {
                    u[i] = true;
                    q.push(i);
                }
            }
        }
    }
}

int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    in >> n;
    for(int i = 0; i < n; ++i) {
        met[i] = 0;
        u[i] = false;
    }
    for(int i = 0; i < n; ++i) {
        for(int j = 0; j < n; ++j) {
            in >> a[i][j];
        }
    }

    for(int i = 0; i < n; ++i) {
        if(!u[i]) {
            bfs(i);
        }
    }

    for(int i = 0; i < n; ++i) {
        out << met[i] << " ";
    }
    return 0;
}
