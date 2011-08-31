#include <stdio.h>
#include <stdlib.h>


typedef struct Node {
  struct Node *next;
  const char *payload;
} Node;


int main(int argc, const char * const argv[])
{
  Node *head = 0;
  int scan;
  
  for (scan = 0; scan < argc; ++scan)
    {
      Node * const node = (Node *) malloc(sizeof(Node));
      node->next = head;
      node->payload = argv[scan];
      head = node;
    }

  while (head)
    {
      Node * const next = head->next;
      printf("arg: %s\n", head->payload);
      free(head);
      head = next;
    }
  
  return 0;
}
