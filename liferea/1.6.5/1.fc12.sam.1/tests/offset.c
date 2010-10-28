static int *displace(int *cell)
{
  return cell + 3;
}


static int bump(int flag)
{
  return flag + 4;
}


void foo(int flag, int *cell)
{
  flag = 3;

  *cell = 8;
  *cell = flag;
  *cell = 3 + flag + 19;
  *(cell + flag) = 7;
  *cell = *cell;
  *(cell + 1) = flag;
  cell[2] = flag;
  
  *(displace(cell)) = flag;
  
  *cell = bump(flag);
  *(cell + 34) = bump(flag);

  *(displace(cell)) = bump(flag);
}
