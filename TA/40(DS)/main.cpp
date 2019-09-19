#include <iostream>
#include <fstream>
#include <iomanip>
#include <set>
#include <algorithm>

using namespace std;

int n;
int sum;
double ans;
int p[100100];
int a[100100];
int b[100100];
int d[100100];
multiset<pair<double, int>> s;

bool comp(int i, int j)
{
    return d[i] < d[j];
}

int main()
{
    ifstream cin("lazy.in");
    ofstream cout("lazy.out");
    cin >> n;
    for (int i = 0; i < n; i++)
    {
        cin >> a[i] >> b[i] >> d[i];
        p[i] = i;
    }
    sort(p, p + n, comp);
    for (int i = 0; i < n; i++)
    {
        sum += b[p[i]];
        s.insert(make_pair(1.0 / a[p[i]], b[p[i]]));
        if (sum <= d[p[i]])
            continue;
        int x = sum - d[p[i]];
        sum = d[p[i]];
        while (x)
        {
            int y = (*s.begin()).second;
            double cost = (*s.begin()).first;
            if (y <= x)
            {
                x -= y;
                ans += cost*y;
                s.erase(s.begin());
            }
            else
            {
                ans += cost*x;
                y -= x;
                x = 0;
                s.erase(s.begin());
                s.insert(make_pair(cost, y));
            }
        }
    }
    cout << fixed << setprecision(2) << ans << endl;
}
