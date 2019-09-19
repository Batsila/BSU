#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

int n, m;
vector<vector<pair<int, long long>>> r;
vector<int> o;
vector<int> st;
vector<int> f;
long long h[200002];
bool u[200002];

void dfs(int v) {
    u[v] = true;
    o.push_back(v);
    for(pair<int, long long> p : r[v]) {
        if(!u[p.first]) {
            h[p.first] = h[v] + p.second;
            dfs(p.first);
            o.push_back(v);
        }
    }
}

void bst(int i, int l, int r) {
    if (l == r) {
        st[i] = o[l];
    }
	else {
		int m = (l + r) / 2;
		bst(2 * i, l, m);
		bst(2 * i + 1, m + 1, r);
		if (h[st[2 * i]] < h[st[2 * i + 1]]) {
            st[i] = st[2 * i];
		}
		else {
            st[i] = st[2 * i +1];
		}
	}
}

int st_min(int i, int sl, int sr, int l, int r) {
	if (sl == l && sr == r) {
        return st[i];
	}
	int sm = (sl + sr) / 2;
	if (r <= sm) {
        return st_min(2 * i, sl, sm, l, r);
	}
	if (l > sm) {
        return st_min(2 * i + 1, sm + 1, sr, l, r);
	}
	int L = st_min(2 * i, sl, sm, l, sm);
	int R = st_min(2 * i + 1, sm + 1, sr, sm + 1, r);
	if(h[L] < h[R]) {
        return L;
	}
	else {
        return R;
	}
}

int lca(int v1, int v2) {
    int l = f[v1];
    int r = f[v2];
    if(l > r) {
        swap(l, r);
    }
    return st_min(1, 0, o.size() - 1, l, r);
}

int main() {
    ifstream cin("input.txt");
    ofstream cout("output.txt");
    cin >> n;
    for(int i = 0; i < n; ++i) {
        vector<pair<int, long long>> temp;
        r.push_back(temp);
    }
    for(int i = 0; i < n - 1; ++i) {
        int v, u;
        long long w;
        cin >> v >> u >> w;
        --u;
        --v;
        r[v].push_back(make_pair(u, w));
        r[u].push_back(make_pair(v, w));
    }
    dfs(0);
    f.assign(n, -1);
    for(int i = 0; i < o.size(); ++i) {
        if(f[o[i]] == -1) {
            f[o[i]] = i;
        }
    }
    st.assign(o.size() * 4 + 1, -1);
    bst(1, 0, o.size() - 1);
    cin >> m;
    for(int i = 0; i < m; ++i) {
        int v1, v2;
        cin >> v1 >> v2;
        --v1;
        --v2;
        cout << h[v1] + h[v2] - 2 * h[lca(v1, v2)] << endl;
    }
    return 0;
}
