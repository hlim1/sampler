typedef struct Node {
  double value;
  struct Node *next;
} Node;


typedef struct Multinode {
  int count;
  Node node;
} Multinode;


void foo()
{
  int x = 7;
  Node a = {3.14, 0};
  Multinode b = {1, {2.73, &a}};
}
