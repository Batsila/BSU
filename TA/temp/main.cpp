#include <iostream>
#include <fstream>
#include <queue>
#include <algorithm>
#include <climits>
#include <map>
#include <iterator>
#include <string.h>

class Edge;
#include <vector>
class Vertex {
public:
	std::vector<Edge*> edges;
	int n;
	Vertex() {

	}
	Vertex(int n) : n(n) {};
};

class Edge {
public:
	Vertex * u, *v;
	long long c;
	long long p;
	long long f;

	Edge* reverse;

	Edge() {

	}
	Edge(Vertex* u, Vertex* v, long long c, long long p) : c(c), p(p), u(u), v(v) {
		f = 0;
	}
};

class Graph {
public:
	std::vector<Edge*> edges;
	std::vector<Vertex*> vertices;
	std::vector<Vertex*> parent;
	long long cMin = LLONG_MAX;

	void addEdge(Edge* e) {
		edges.push_back(e);
		e->u->edges.push_back(e);
	}

	void addVertex(Vertex* v) {
		v->n = vertices.size();
		vertices.push_back(v);
	}

	std::deque<Edge*>* bfs(Vertex* s, Vertex* t) {
		cMin = LLONG_MAX;
		std::deque<Vertex*> queue;
		Edge** path = new Edge*[vertices.size()];
		memset(path, 0, sizeof(Edge*) * vertices.size());
		queue.push_back(s);

		while (queue.size() > 0) {
			Vertex* u = queue[0];
			queue.pop_front();
			if (u == t) {
				auto result = new std::deque<Edge*>();
				while (u->n != 0) {
					result->push_front(path[u->n]);
					cMin = std::min(cMin, path[u->n]->c - path[u->n]->f);
					u = path[u->n]->u;
				}
				delete[] path;
				return result;
			}
			for (Edge* e : u->edges) {
				if (!path[e->v->n] && (e->c - e->f > 0)) {
					path[e->v->n] = e;
					queue.push_back(e->v);
				}
			}
		}

		delete[] path;
		return nullptr;
	}

	long long ff(int s, int t) {
		long long flow = 0;

		auto l = this->bfs(this->vertices[s], this->vertices[t]);
		while (l) {
			for (auto x : *l) {
				x->f += this->cMin;
				x->reverse->f -= this->cMin;

			}
			flow += this->cMin;
			l = this->bfs(this->vertices[s], this->vertices[t]);
		}

		return flow;

	}

	std::vector<Edge*>* bellman(int s) {
		long long* d = new long long[vertices.size()];
		long long* p = new long long[vertices.size()];

		Edge** cantParent = new Edge*[edges.size()];

		int flag;
		Edge* edgeFlag = new Edge();

		for (auto v : vertices) {
			d[v->n] = LLONG_MAX;
			p[v->n] = -1;
		}
		d[s] = 0;

		for (int i = 0; i < vertices.size() - 1; i++) {
			flag = -1;
			for (auto e : edges) {
				if ((e->c - e->f > 0) && (d[e->v->n] > d[e->u->n] + e->p)) {
					d[e->v->n] = std::max(d[e->u->n] + e->p, LLONG_MIN);
					p[e->v->n] = e->u->n;
					cantParent[e->v->n] = e;
					flag = e->v->n;
					edgeFlag = e;
				}
			}
		}
		std::vector<Edge*>* path = new std::vector<Edge*>();

		if (flag != -1) {
			int y = flag;
			Edge* edgeY = edgeFlag;
			for (int i = 0; i < vertices.size(); i++) {
				y = p[y];
				edgeY = cantParent[edgeY->v->n];
			}

			for (int cur = y; ;cur = p[cur]) {
				(*path).push_back(cantParent[cur]);
				if (cur == y &&(*path).size() > 1) {
					break;
				}
			}
			reverse((*path).begin(), (*path).end());
		}

		if ((*path).size() > 0) {
			(*path).pop_back();
		}
		return path;
	}

	long long minCostFlow(int s, int t) {
		std::vector<Edge*>* cycle = this->bellman(0);
		long long addFlow = LLONG_MAX;
		Edge *e;

		while (cycle->size() > 2) {
			e = (*cycle)[0];
			for (int i = 0; i < (*cycle).size(); i++) {
				addFlow = std::min(addFlow, (*cycle)[i]->c - (*cycle)[i]->f);
			}

			for (int i = 0; i < (*cycle).size(); i++) {
				(*cycle)[i]->f += addFlow;
				(*cycle)[i]->reverse->f -= addFlow;
			}

			cycle = bellman(s);
		}

		long long minCost = 0;
		for (auto e : edges) {
			if (e->f > 0) {
				minCost += e->p * e->f;
			}
		}

		return minCost;
	}
};

int main()
{

	std::ifstream in("input.txt");
	std::ofstream out("output.txt");

	int n, m, sn, tn;
	Vertex *s, *t;

	in >> n >> m >> sn >> tn;

	std::map<std::pair<int, int>, Edge*> edges;
	Graph* graph = new Graph();

	for (int i = 0; i < n; i++) {
		graph->addVertex(new Vertex());
	}

	for (int i = 0; i < m; i++) {
		Edge *e1, *e2;

		int u, v;
		long long c, p;
		in >> u >> v >> c >> p;

		e1 = new Edge(graph->vertices[v - 1], graph->vertices[u - 1], 0, -p);
		graph->addEdge(e1);
		e2 = new Edge(graph->vertices[u - 1], graph->vertices[v - 1], c, p);
		graph->addEdge(e2);
		e1->reverse = e2;
		e2->reverse = e1;

		std::pair<int, int> k = std::make_pair(u - 1, v - 1);
		edges.insert(std::make_pair(k, e2));

	}
	long long flow = graph->ff(sn - 1, tn - 1);
	long long minCost = graph->minCostFlow(sn, tn);

	Graph* suggested = new Graph();
	for (int i = 0; i < n; i++) {
		suggested->addVertex(new Vertex());
	}

	int x, y;

	while (!in.eof()) {
		in >> x;
		in >> y;
		x--;
		y--;
		std::pair<int, int> k = std::make_pair(x, y);
		std::map<std::pair<int, int>, Edge*>::iterator it = edges.find(k);
		Edge* e = it->second;
		Edge* eToAdd = new Edge(suggested->vertices[e->u->n], suggested->vertices[e->v->n], e->c, e->p);
		suggested->vertices[e->u->n]->edges.push_back(eToAdd);
		Edge* reverseEToAdd = new Edge(suggested->vertices[e->v->n], suggested->vertices[e->u->n], 0, -e->p);
		suggested->vertices[e->v->n]->edges.push_back(reverseEToAdd);
		eToAdd->reverse = reverseEToAdd;
		reverseEToAdd->reverse = eToAdd;

		suggested->edges.push_back(eToAdd);
		suggested->edges.push_back(reverseEToAdd);
	}

	long long sugFlow = suggested->ff(sn - 1, tn - 1);
	long long sugCost = suggested->minCostFlow(sn, tn);

	if (sugCost > minCost || sugFlow != flow) {
		out << "No" << '\n' << flow << '\n' << minCost << '\n' << sugFlow << '\n' << sugCost;
	}
	else {
		out << "Yes" << '\n' << flow << '\n' << minCost;
	}
	return 0;
}
