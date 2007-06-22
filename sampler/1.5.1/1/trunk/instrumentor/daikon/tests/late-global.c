int early;
int counter;

void incr()
{
  ++counter;
}

int late;

void decr()
{
  --counter;
}


int main()
{
  incr();
  decr();
  return 0;
}
