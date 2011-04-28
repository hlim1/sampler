int five()
{
  return 5;
}


int main()
{
  int x __attribute__((unused)) = five();
  five();

  return 0;
}
