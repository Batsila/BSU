import java.io.*;
import java.util.Scanner;
import java.util.Vector;

public class Solution implements Runnable {

    static Vector<Long> v = new Vector<>();

    private static class Tree {

        class Node {
            Node l, r, parent;
            long nodes;
            long key;
            Node(long key) {
                this.key = key;
                this.l = null;
                this.r = null;
                this.parent = null;
                this.nodes = 1;
            }
        }

        Node head;

        Tree(long key) {
            head = new Node(key);
        }

        void addNode(long key, Node node) {
            if(node == null) {
                node = new Node(key);
            }
            if(key < node.key) {
                if(node.l == null){
                    node.l = new Node(key);
                    node.l.parent = node;
                    Node temp = node;
                    temp.nodes += 1;
                    while(temp.parent != null) {
                        temp = temp.parent;
                        temp.nodes += 1;
                    }
                }
                else {
                    addNode(key, node.l);
                }
            }
            if(key > node.key) {
                if(node.r == null) {
                    node.r = new Node(key);
                    node.r.parent = node;
                    Node temp = node;
                    temp.nodes += 1;
                    while(temp.parent != null) {
                        temp = temp.parent;
                        temp.nodes += 1;
                    }
                }
                else {
                    addNode(key, node.r);
                }
            }

        }

        void leftPreOrdered(Node node, PrintWriter out) {
            if(node != null){
                out.println(node.key);
                leftPreOrdered(node.l, out);
                leftPreOrdered(node.r, out);
            }
        }

        void find(Node node) {
            if (node != null) {
                long l, r;
                if (node.l == null) {
                    l = 0;
                } else {
                    l = node.l.nodes;
                }
                if (node.r == null) {
                    r = 0;
                } else {
                    r = node.r.nodes;
                }
                if (Math.abs(l - r) == 1) {
                    v.add(node.key);
                }
                find(node.l);
                find(node.r);
            }
        }

        void deleteNode(long key, Node node) {
            if(key == node.key) {
                if(node.r != null) {
                    if(node.l != null) {
                        Node temp = node.r;
                        if(temp.l != null) {
                            while(temp.l != null){
                                temp = temp.l;
                            }
                            node.key = temp.key;
                            temp.parent.l = temp.r;
                        }
                        else {
                            node.key = temp.key;
                            temp.parent.r = temp.r;
                        }
                    }
                    else {
                        node.key = node.r.key;
                        node.l = node.r.l;
                        node.r = node.r.r;
                    }
                }
                else {
                    if(node.l != null) {
                        node.key = node.l.key;
                        node.r = node.l.r;
                        node.l = node.l.l;
                    }
                    else {
                        if(node.parent != null) {
                            if(node.parent.l != null && node.parent.l.key == node.key) {
                                node.parent.l = null;
                            }
                            else {
                                node.parent.r = null;
                            }
                        }
                        else {
                            node = null;
                        }
                    }
                }
                return;
            }
            if(key < node.key) {
                if(node.l != null) {
                    deleteNode(key, node.l);
                }
                else {
                    return;
                }
            }
            if(key > node.key) {
                if(node.r != null) {
                    deleteNode(key, node.r);
                }
            }
        }
    }

    public static void main(String[] args) throws IOException {
        new Thread(null, new Solution(), "", 64 * 1024 * 1024).start();
    }
    public void run() {
        try {
            Scanner in = new Scanner(new File("in.txt"));
            PrintWriter out = new PrintWriter(new FileWriter("out.txt"));
            Tree tree = null;
            tree = new Tree(in.nextLong());
            while (in.hasNext()) {
                long x = in.nextLong();
                tree.addNode(x, tree.head);
            }
            tree.find(tree.head);
            long sum = 0;
            for(long i : v) {
                sum += i;
            }
            long key = sum / v.size();
            if(v.contains(key)) {
                tree.deleteNode(key, tree.head);
            }
            tree.leftPreOrdered(tree.head, out);
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
