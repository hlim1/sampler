static int foo()
{
  return 7;
}


void bar(int *y)
{
  *y = foo(*y);
}
