void ping();


int x;


void pong()
{
 top:
  if (x)
    {
      ping();
      goto top;
    }
}


int tiny(int x)
{
  int result = 9;

  if (x)
    ping();
  else
    pong();

  return result;
}
