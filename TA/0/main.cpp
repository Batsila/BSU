#include <fstream>
#include <set>

using namespace std;

long long answer = 0;
set<long long> tree;

int main() {
    ifstream in("input.txt");
    ofstream out("output.txt");
    while(!in.eof()) {
        long long temp;
        in >> temp;
        tree.insert(temp);
    }
    for(long long x : tree) {
        answer += x;
    }
    out << answer << endl;
    return 0;
}
