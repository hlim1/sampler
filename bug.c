void foo()
{
  int row;

  switch (row)
    {
    default:
      foo();
      row = 0;
    }
}
