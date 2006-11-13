typedef struct Node {
  double value;
  struct Node *next;
} Node;


typedef struct Multinode {
  int count;
  Node node;
} Multinode;


int main()
{
  int x = 7;
  Node a = {3.14, 0};
  Multinode b = {x, a};
  b.node.next = &a;

  return 0;
}
