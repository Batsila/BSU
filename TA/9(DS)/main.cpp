#include <iostream>
#include <fstream>
#include <set>
#include <cmath>
#define INF 10000000
using namespace std;

const int MAXN = 1111;
int n, m;
int i0, j0, v;
int a[MAXN][MAXN];
int ans = 0;

struct element
{
    int x;
    int y;
    bool operator < (const element &other) const
    {
        return a[this->x][this->y] < a[other.x][other.y];
    }
};

set<element> s;

int main()
{
    ifstream in("in.txt");
    ofstream out("out.txt");
    in >> n;
    in >> m;
    in >> i0;
    in >> j0;
    in >> v;
    for(int i = 0; i < n + 2; ++i)
    {
        for(int j = 0; j < m + 2; ++j)
        {
            if(i == 0 || i == n + 1 || j == 0 || j == m + 1)
            {
                a[i][j] = 0;
            }
            else
            {
                in >> a[i][j];
            }

        }
    }
    element first;
    first.x = i0;
    first.y = j0;
    s.insert(first);
    int dx[] = {0, 1, 0, -1};
    int dy[] = {1, 0, -1, 0};
    while(true)
    {
        element c = *s.begin();
        if(a[c.x][c.y] == 0)
        {
            break;
        }
        s.erase(c);
        for(int i = 0; i < 4; ++i)
        {
            element n;
            n.x = c.x + dx[i];
            n.y = c.y + dy[i];
            if(a[n.x][n.y] > a[c.x][c.y]) {
                s.insert(n);
                P = min(P, a[n.x][n.y]);
            }
        }
        if(P > a[c.x][c.y])
        {
            ans += P - a[c.x][c.y];
            a[c.x][c.y] = -P;
        }
    }
    cout << ans << endl;
    return 0;
}
