int *pointer;
int value;


void foo(int flag)
{
  if (flag)
    a: goto b;
  else
    b: goto a;
}
