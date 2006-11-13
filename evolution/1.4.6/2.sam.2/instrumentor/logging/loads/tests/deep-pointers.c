int main()
{
  int v0;
  int *v1 = &v0;
  int **v2 = &v1;
  int ***v3 = &v2;
  int ****v4 = &v3;
  ****v4 = 14;

  return 0;
}
