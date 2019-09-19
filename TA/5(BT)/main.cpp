#include <fstream>
#include <vector>
#include <map>

using namespace std;

ifstream in("in.txt");
ofstream out("out.txt", ios_base::trunc);

struct Node {
    long long key;
    Node* l;
    Node* r;
    Node* perent;
    int leafs_number = 0;
};

map<long long, Node*> leafs;
vector<long long> leaf;

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
        leafs.insert(make_pair(tree->key, tree));
    }
    if(key < tree->key) {
        if(tree->l == NULL){
            tree->l = new Node;
            tree->l->key = key;
            tree->l->l = tree->l->r = NULL;
            tree->l->perent = tree;
            leafs.erase(tree->key);
            leafs.insert(make_pair(tree->l->key, tree->l));
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
            leafs.erase(tree->key);
            leafs.insert(make_pair(tree->r->key, tree->r));
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
    while(!in.eof()) {
        long long temp;
        in >> temp;
        add_node(temp, tree);
    }
    for(map<long long, Node*>::iterator i = leafs.begin(); i != leafs.end(); ++i) {
        leaf.push_back(i->first);
        Node* temp = i->second;
        temp->leafs_number = 1;
        while(temp->perent != NULL) {
            temp = temp->perent;
            temp->leafs_number += 1;
        }
    }
    vector<long long> way;
    long long sum = 9223372036854775807;
    int length = 2147483647;
    long long root_key = 9223372036854775807;
    for(long long i = 0; i < leaf.size() - 1; ++i) {
        for(long long j = i + 1; j < leaf.size(); ++j) {
            long long k = j - i - 1;
            Node* temp = leafs.find(leaf[i])->second;
            vector<long long> temp_way;
            long long temp_sum = 0;
            int temp_length = 0;
            long long temp_root_key = 0;

            while(true) {
                temp_way.push_back(temp->key);
                ++temp_length;
                temp_sum += temp->key;
                if(temp->r == NULL || temp_way[temp_way.size() - 2] == temp->r->key) {
                    temp = temp->perent;
                }
                else {
                    if(temp->perent == NULL) {
                        temp_root_key = temp->key;
                        temp = temp->r;
                        break;
                    }
                    else {
                        if(temp->r->leafs_number > k) {
                            temp_root_key = temp->key;
                            temp = temp->r;
                            break;
                        }
                        else {
                            k -= temp->r->leafs_number;
                            temp = temp->perent;
                        }
                    }

                }
            }
            while(true) {
                temp_way.push_back(temp->key);
                ++temp_length;
                temp_sum += temp->key;
                if(temp->l == NULL) {
                    if(temp->r == NULL) {
                        break;
                    }
                    else {
                        temp = temp->r;
                    }
                }
                else {
                    if(temp->r == NULL) {
                        temp = temp->l;
                    }
                    else {
                        if(temp->l->leafs_number > k) {
                            temp = temp->l;
                        }
                        else {
                            k -= temp->l->leafs_number;
                            temp = temp->r;
                        }
                    }
                }
            }
            if(temp_length < length) {
                length = temp_length;
                sum = temp_sum;
                root_key = temp_root_key;
                way = temp_way;
            }
            else {
                if(temp_length == length) {
                    if(temp_sum < sum) {
                        length = temp_length;
                        sum = temp_sum;
                        root_key = temp_root_key;
                        way = temp_way;
                    }
                    else {
                        if(temp_sum == sum) {
                            if(temp_root_key < root_key){
                                length = temp_length;
                                sum = temp_sum;
                                root_key = temp_root_key;
                                way = temp_way;
                            }
                        }
                    }
                }
            }
        }
    }
    if(way.size() % 2 == 1) {
        delete_node(way[way.size() / 2], tree);
    }
    left_pre_ordered(tree);
    return 0;
}
