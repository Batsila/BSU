    #include <iostream>
    #include <fstream>
    #include <cmath>
    #include <set>
    #define mkp make_pair
    #define inf 1000000000

    using namespace std;
    typedef long long ll;

    int n, m;
    int ans;
    int w[505][505];
    int xs, ys, xf, yf;
    int p[505][505];
    int d[505][505];
    int a[505][505];
    set<pair<int, int>> used;

    int main()
    {
    	ifstream cin("walk.in");
    	ofstream cout("walk.out");
    	cin >> n >> m;
    	for (int i = 0; i < n; i++) {
    		for (int j = 0; j < m; j++) {
    			char c;
    			cin >> c;
    			if (c == '*') {
    				a[i][j] = 1;
    			}
    			if (c == 'M') {
    				xs = i;
    				ys = j;
    			}
    			if (c == 'G') {
    				xf = i;
    				yf = j;
    			}
    		}
    	}
    	for (int i = 0; i <= n; i++) {
    		for (int j = 0; j <= m; j++) {
    			d[i][j] = inf;
    		}
    	}
    	d[xs][ys] = 0;
    	set<pair<int, int>> s;
    	s.insert(mkp(0, xs * 1000 + ys));
    	while (!s.empty()) {
    		int v = (*s.begin()).second;
    		int dist = (*s.begin()).first;
    		s.erase(s.begin());
    		int x = v / 1000;
    		int y = v % 1000;
    		for (int i = x - 1; i <= x + 1; i++) {
    			for (int j = y - 1; j <= y + 1; j++) {
    				if (i >= 0 && i < n && j >= 0 && j < m && abs(i - x) + abs(j - y) == 1 && !a[i][j] && d[i][j] > d[x][y] + 1) {
    					s.erase(mkp(d[i][j], i * 1000 + j));
    					d[i][j] = d[x][y] + 1;
    					p[i][j] = x * 1000 + y;
    					s.insert(mkp(d[i][j], i * 1000 + j));
    				}
    			}
    		}
    	}
    	ans = d[xf][yf];
    	if (ans == inf) {
    		cout << -1 << endl;
    		return 0;
    	}
    	for (int i = 0; i <= n; i++) {
    		for (int j = 0; j <= m; j++) {
    			w[i][j] = 10000;
    		}
    	}
    	int v = xf * 1000 + yf;
    	while (v != xs*1000 + ys) {
    		w[v / 1000][v % 1000] = d[xf][yf]--;
    		used.insert(mkp(p[v / 1000][v % 1000], v));
    		v = p[v / 1000][v % 1000];
    	}
    	for (int i = 0; i <= n; i++) {
    		for (int j = 0; j <= m; j++) {
    			d[i][j] = inf;
    		}
    	}
    	d[xs][ys] = 0;
    	s.insert(mkp(0, xs * 1000 + ys));
    	while (!s.empty()) {
    		int v = (*s.begin()).second;
    		int dist = (*s.begin()).first;
    		s.erase(s.begin());
    		int x = v / 1000;
    		int y = v % 1000;
    		for (int i = x - 1; i <= x + 1; i++) {
    			for (int j = y - 1; j <= y + 1; j++) {
    				if (i >= 0 && i < n && j >= 0 && j < m && abs(i - x) + abs(j - y) == 1 && !a[i][j] && used.find(mkp(v, i*1000+j)) == used.end()) {
    					int len = w[i][j] - w[x][y];
    					len += used.find(mkp(i * 1000 + j, v)) == used.end() ? 1 : -1;
    					if (d[i][j] > d[x][y] + len) {
    						s.erase(mkp(d[i][j], i * 1000 + j));
    						d[i][j] = d[x][y] + len;
    						p[i][j] = x * 1000 + y;
    						s.insert(mkp(d[i][j], i * 1000 + j));
    					}
    				}
    			}
    		}
    	}
    	ans += d[xf][yf] + w[xs][ys] - w[xf][yf];
    	if (ans >= inf) {
    		cout << -1 << endl;
    	} else {
    		cout << ans << endl;
    	}
    }
