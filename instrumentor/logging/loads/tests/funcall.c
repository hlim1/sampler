double sqrt(double);


void subsubwork()
{
  sqrt(2.);
}


void subwork()
{
  subsubwork();
  sqrt(2.);
  subsubwork();
}


void core()
{
  int source = 2;
  int dest;

  subwork();
  
  dest = source;
}


void work()
{
  core();
}


int main(int argc, char *argv[])
{
  int count;
  char **args;

  count = argc;
  work();
  args = argv;
}
