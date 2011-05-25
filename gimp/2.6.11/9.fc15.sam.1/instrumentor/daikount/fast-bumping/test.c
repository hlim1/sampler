unsigned counters[3];


int bump(int left, int right)
{
#if 0
  int lt = 0;
  int le = 0;

  /* !!!: gcc removes the zero initializations ... drat */

  asm
    ("cmp %2,%3\n"
     "setl %b0\n"
     "setle %b1\n"
     : "+&q,&q" (lt), "+&q,&q" (le)
     : "r,g" (left), "g,r" (right)
     : "cc");

  ++counters[lt + le];
#endif

  ++counters[(left >= right) + (left > right)];
}
