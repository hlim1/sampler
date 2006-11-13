extern const unsigned *nextEventPrecomputed;
extern unsigned getNextEventCountdown();

int main()
{
  return nextEventPrecomputed[0] + getNextEventCountdown();
}
