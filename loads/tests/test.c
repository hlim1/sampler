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
  int result = 0;
  
  {
    int x = 7;
    Node a = {3.14, 0};
    Multinode b = {x, a};
    b.node.next = &a;
    b.node.next->value = 2.7;
  }

  {
    int values[] = {1, 2, 3, 4, 5};
    int index = 2;
    int direct = values[3];
    int indirect = values[index];
  }

  {
    int addend = 3;
    int total = addend + addend * addend;
  }

  {
    int predicate = 19;
    if (predicate)
      predicate = 0;
  }

  return result;
}
