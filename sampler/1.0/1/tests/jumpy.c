

int main(int argc, const char * const argv[])
{
  int value = 0;
  
 backward:

  if (argc)
    goto backward;

  if (argc)
    goto forward;

  value = 1;

 forward:

  return 0;
}
