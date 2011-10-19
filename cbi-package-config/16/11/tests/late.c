void foo(int flag, int *cell)
{
  while (flag)
    ++flag;

  while (flag)
    --flag;

  *cell = flag;
  *cell = flag;
  *cell = flag;
  *cell = flag;
  *cell = flag;
}
