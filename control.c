int *pointer;


void foo(int flag)
{
  while (flag)
    while (flag)
      {
	++*pointer;
	foo(flag);
	foo(flag);
	++*pointer;
      }
  
  if (flag)
    ++*pointer;

  do
    {
      ++*pointer;
      foo(flag);
    }
  while(flag);

  return;
}
