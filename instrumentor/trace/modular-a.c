void component(void);


int main(int argc, char *argv[])
{
  if (argv[0][0])
    argv[0][0] = 'z';

  component();

  if (argc > 1 && argc > 2)
    return 1;
  else
    return 0;
}
