void foo(int flag)
{
  while (flag)
    while (flag)
      ++flag;
  
  if (flag)
    ++flag;

  do
    ++flag;
  while(flag);

  return;
}
