#include <fstream>

using namespace std;

ifstream in("input.txt");
ofstream out("output.txt");

struct Node {
    long long key;
    Node* l;
    Node* r;
};

void left_pre_ordered(Node *&tree) {
    if(tree != NULL){
        out << tree->key << endl;
        left_pre_ordered(tree->l);
        left_pre_ordered(tree->r);
    }
}

void add_node(long long key, Node *&tree) {
    if(tree == NULL) {
        tree = new Node;
        tree->key = key;
        tree->l = tree->r = NULL;
    }
    if(key < tree->key) {
        if(tree->l == NULL){
            tree->l = new Node;
            tree->l->key = key;
            tree->l->l = tree->l->r = NULL;
        }
        else {
            add_node(key, tree->l);
        }
    }
    if(key > tree->key) {
        if(tree->r == NULL) {
            tree->r = new Node;
            tree->r->key = key;
            tree->r->l = tree->r->r = NULL;
        }
        else {
            add_node(key, tree->r);
        }
    }
}

int main() {
    Node* tree = NULL;
    while(!in.eof()) {
        long long temp;
        in >> temp;
        add_node(temp, tree);
    }
    left_pre_ordered(tree);
    return 0;
}
