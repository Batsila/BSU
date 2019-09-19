    #include <iostream>
    #include <fstream>
    #include <vector>
    #include <algorithm>
    #include <time.h>
    #define inf 1000000000

    using namespace std;

    struct edge {
    	int to, num;
    };

    int n, m, k;
    int a[1000];
    int cost[1000];
    int used[1000];
    int bad[1000];
    int mark[1000];
    int best = inf;
    vector<edge> vec[1000];
    vector<int> ans;
    vector<int> del;

    int dfs(int v, int mask) {
    	used[v] = 1;
    	int cnt = bad[v];
    	for (int i = 0; i < vec[v].size(); i++) {
    		if (mark[vec[v][i].num] || used[vec[v][i].to]) {
    			continue;
    		}
    		if (mask & (1 << (vec[v][i].to - 1))) {
    			mark[vec[v][i].num] = 1;
    			del.push_back(vec[v][i].num);
    			continue;
    		}
    		cnt += dfs(vec[v][i].to, mask);
    	}
    	return cnt;
    }

    int dfs2(int v, int mask) {
    	used[v] = 1;
    	int cnt = bad[v];

    	for (int i = 0; i < vec[v].size(); i++) {
    		if (mask & (1 << (vec[v][i].num - 1))) {
    			continue;
    		}
    		if (used[vec[v][i].to])
    			continue;
    		cnt = cnt + dfs2(vec[v][i].to, mask);
    	}
    	return cnt;
    }

    int main() {
    	ifstream cin("input.txt");
    	ofstream cout("output.txt");
    	int start = clock();
    	cin >> n >> m;
    	for (int i = 1; i <= m; i++) {
    		int u, v, c;
    		cin >> u >> v >> c;
    		cost[i] = c;
    		edge e;
    		e.to = v;
    		e.num = i;
    		vec[u].push_back(e);
    		e.to = u;
    		vec[v].push_back(e);
    	}
    	cin >> k;
    	for (int i = 0; i < k; i++) {
    		cin >> a[i];
    		bad[a[i]] = 1;
    	}
    	if (m <= 20) {
    		for (int mask = 0; mask < (1 << m); mask++) {
    			int sum = 0;
    			for (int i = 1; i <= m; i++) {
    				sum += cost[i] * ((mask & (1 << (i - 1))) != 0);
    			}
    			if (sum >= best) {
    				continue;
    			}
    			for (int i = 1; i <= n; i++) {
    				used[i] = 0;
    			}
    			int ok = true;
    			for (int i = 1; i <= n; i++) {
    				if (used[i]) {
    					continue;
    				}
    				ok &= (dfs2(i, mask) <= 1);
    			}
    			if (!ok) {
    				continue;
    			}
    			best = sum;
    			ans.clear();
    			for (int i = 1; i <= m; i++) {
    				if ((mask & (1 << (i - 1))) == 0) {
    					continue;
    				}
    				ans.push_back(i);
    			}
    		}
    		cout << best << endl << ans.size() << endl;
    		for (int i = 0; i < ans.size(); i++) {
    			cout << ans[i] << endl;
    		}
    		return 0;
    	}
    	vector<int> masks_to_try;
    	for (int mask = 0; mask < (1 << n); mask++)
    	{
    		int cnt = 0;
    		for (int i = 1; i <= n; i++)
    			cnt += bad[i] * ((mask & (1 << (i - 1))) == 0);
    		if (cnt == 1)
    			masks_to_try.push_back(mask);
    	}
    	srand(time(0));
    	while (clock() - start < 1900)
    	{
    		random_shuffle(a, a + k);
    		vector<int> ans_it;
    		int current_best = 0;
    		for (int i = 0; i < k; i++) {
    			int res = inf;
    			vector<int> del;
    			for (int mask = 0; mask < masks_to_try.size(); mask++) {
    				for (int j = 1; j <= n; j++) {
    					used[j] = 0;
    				}
    				int cnt = dfs(a[i], masks_to_try[mask]);
    				if (cnt == 1) {
    					int sum = 0;
    					for (int j = 0; j < ::del.size(); j++) {
    						sum += cost[::del[j]];
    					}
    					if (sum < res) {
    						res = sum;
    						del.clear();
    						for (int j = 0; j < ::del.size(); j++) {
    							del.push_back(::del[j]);
    						}
    					}
    				}
    				for (int j = 0; j < ::del.size(); j++) {
    					mark[::del[j]] = 0;
    				}
    				::del.clear();
    			}
    			for (int j = 0; j < del.size(); j++) {
    				ans_it.push_back(del[j]);
    				current_best += cost[del[j]];
    				mark[del[j]] = 1;
    			}
    		}
    		for (int i = 0; i < ans_it.size(); i++) {
    			mark[ans_it[i]] = 0;
    		}
    		if (current_best < best) {
    			best = current_best;
    			ans.clear();
    			for (int i = 0; i < ans_it.size(); i++) {
    				ans.push_back(ans_it[i]);
    			}
    		}
    	}
    	cout << best << endl << ans.size() << endl;
    	sort(ans.begin(), ans.end());
    	for (int i = 0; i < ans.size(); i++) {
    		cout << ans[i] << endl;
    	}
    }
