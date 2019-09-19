#include <fstream>

using namespace std;

ifstream in("input.txt");
ofstream out("output.txt", ios_base::trunc);

struct Node {
    long long key;
    Node* l;
    Node* r;
    Node* perent;
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
        tree->perent = NULL;
    }
    if(key < tree->key) {
        if(tree->l == NULL){
            tree->l = new Node;
            tree->l->key = key;
            tree->l->l = tree->l->r = NULL;
            tree->l->perent = tree;
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
            tree->r->perent = tree;
        }
        else {
            add_node(key, tree->r);
        }
    }
}

void delete_node(long long key, Node *&tree) {
    if(key == tree->key) {
        if(tree->r != NULL) {
            if(tree->l != NULL) {
                Node* temp = tree->r;
                if(temp->l != NULL) {
                    while(temp->l != NULL){
                        temp = temp->l;
                    }
                    tree->key = temp->key;
                    temp->perent->l = temp->r;
                }
                else {
                    tree->key = temp->key;
                    temp->perent->r = temp->r;
                }
            }
            else {
                tree->key = tree->r->key;
                tree->l = tree->r->l;
                tree->r = tree->r->r;
            }
       }
       else {
            if(tree->l != NULL) {
                tree->key = tree->l->key;
                tree->r = tree->l->r;
                tree->l = tree->l->l;
            }
            else {
                if(tree->perent != NULL) {
                    if(tree->perent->l != NULL && tree->perent->l->key == tree->key) {
                        tree->perent->l = NULL;
                    }
                    else {
                        tree->perent->r = NULL;
                    }
                }
                else {
                    tree = NULL;
                }
            }
       }
       return;
    }
    if(key < tree->key) {
        if(tree->l != NULL) {
            delete_node(key, tree->l);
        }
        else {
            return;
        }
    }
    if(key > tree->key) {
        if(tree->r != NULL) {
            delete_node(key, tree->r);
        }
        else {
            return;
        }
    }
}

int main() {
    Node* tree = NULL;
    long long key;
    in >> key;
    while(!in.eof()) {
        long long temp;
        in >> temp;
        add_node(temp, tree);
    }
    delete_node(key, tree);
    left_pre_ordered(tree);
    return 0;
}
