#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>


#define NUM_TRIALS 50
#define NUM_VALUES (1024 * 1024)

int basis;
int values[NUM_VALUES];

enum { Lesser, Equal, Greater };
unsigned counters[3] = { 0, 0, 0 };


void a()
{
  int trial, value;
  struct timeval begin, end, elapsed;

  counters[Lesser] = counters[Equal] = counters[Greater] = 0;
  srandom(1);
  gettimeofday(&begin, 0);

  for (trial = 0; trial < NUM_TRIALS; ++trial)
    for (value = 0; value < NUM_VALUES; ++value)
      {
	const int count = values[value];
	counters[Lesser] += (count < basis);
	counters[Equal] += (count == basis);
	counters[Greater] += (count > basis);
      }

  gettimeofday(&end, 0);
  timersub(&end, &begin, &elapsed);
  printf("a\t%f\t%u\t%u\t%u\n", elapsed.tv_sec + elapsed.tv_usec / 1000000.,
	 counters[Lesser], counters[Equal], counters[Greater]);
}


void b()
{
  int trial, value;
  struct timeval begin, end, elapsed;

  counters[Lesser] = counters[Equal] = counters[Greater] = 0;
  srandom(1);
  gettimeofday(&begin, 0);

  for (trial = 0; trial < NUM_TRIALS; ++trial)
    for (value = 0; value < NUM_VALUES; ++value)
      {
	const int count = values[value];
	if (count < basis)
	  ++counters[Lesser];
	else if (count == basis)
	  ++counters[Equal];
	else
	  ++counters[Greater];
      }

  gettimeofday(&end, 0);
  timersub(&end, &begin, &elapsed);
  printf("b\t%f\t%u\t%u\t%u\n", elapsed.tv_sec + elapsed.tv_usec / 1000000.,
	 counters[Lesser], counters[Equal], counters[Greater]);
}


void d()
{
  int trial, value;
  struct timeval begin, end, elapsed;

  counters[Lesser] = counters[Equal] = counters[Greater] = 0;
  srandom(1);
  gettimeofday(&begin, 0);

  for (trial = 0; trial < NUM_TRIALS; ++trial)
    for (value = 0; value < NUM_VALUES; ++value)
      {
	int lt;
	int le;

	/* !!!: Avoid the bug in the following version by
	   zero-initializing within the assembly code. */

	asm ("xor %0,%0\n"
	     "xor %1,%1\n"
	     "cmp %2,%3\n"
	     "setl %b0\n"
	     "setle %b1\n"
	     :
	     "=&r,&r" (lt),
	     "=&r,&r" (le)
	     :
	     "r,g" (values[value]),
	     "g,r" (basis)
	     :
	     "cc");

	++counters[lt + le];
      }

  gettimeofday(&end, 0);
  timersub(&end, &begin, &elapsed);
  printf("d\t%f\t%u\t%u\t%u\n", elapsed.tv_sec + elapsed.tv_usec / 1000000.,
	 counters[Lesser], counters[Equal], counters[Greater]);
}


void e()
{
  int trial, value;
  struct timeval begin, end, elapsed;

  counters[Lesser] = counters[Equal] = counters[Greater] = 0;
  srandom(1);
  gettimeofday(&begin, 0);

  for (trial = 0; trial < NUM_TRIALS; ++trial)
    for (value = 0; value < NUM_VALUES; ++value)
      {
	int lt = 0;
	int le = 0;

	/* !!!: gcc removes the zero initialization of "ge".  This
	   seems like an error, because it is declared as an
	   input/output parameter in the asm directive.  Weird. */

	asm ("cmp %2,%3\n"
	     "setl %b0\n"
	     "setle %b1\n"
	     :
	     "+r,r" (lt),
	     "+r,r" (le)
	     :
	     "r,g" (values[value]),
	     "g,r" (basis)
	     :
	     "cc");

	++counters[lt + le];
      }

  gettimeofday(&end, 0);
  timersub(&end, &begin, &elapsed);
  printf("e\t%f\t%u\t%u\t%u\n", elapsed.tv_sec + elapsed.tv_usec / 1000000.,
	 counters[Lesser], counters[Equal], counters[Greater]);
}


void f()
{
  int trial, value;
  struct timeval begin, end, elapsed;

  counters[Lesser] = counters[Equal] = counters[Greater] = 0;
  srandom(1);
  gettimeofday(&begin, 0);

  for (trial = 0; trial < NUM_TRIALS; ++trial)
    for (value = 0; value < NUM_VALUES; ++value)
      {
	const int left = values[value];
	const int right = basis;
	++counters[(left >= right) + (left > right)];
      }

  gettimeofday(&end, 0);
  timersub(&end, &begin, &elapsed);
  printf("f\t%f\t%u\t%u\t%u\n", elapsed.tv_sec + elapsed.tv_usec / 1000000.,
	 counters[Lesser], counters[Equal], counters[Greater]);
}


void g()
{
  int trial, value;
  struct timeval begin, end, elapsed;

  counters[Lesser] = counters[Equal] = counters[Greater] = 0;
  srandom(1);
  gettimeofday(&begin, 0);

  for (trial = 0; trial < NUM_TRIALS; ++trial)
    for (value = 0; value < NUM_VALUES; ++value)
      {
	int lt;
	int le;

	asm ("cmp %2,%3\n"
	     "mov $0,%0\n"
	     "mov $0,%1\n"
	     "setl %b0\n"
	     "setle %b1\n"
	     :
	     "=r,r" (lt),
	     "=r,r" (le)
	     :
	     "r,g" (values[value]),
	     "g,r" (basis)
	     :
	     "cc");

	++counters[lt + le];
      }

  gettimeofday(&end, 0);
  timersub(&end, &begin, &elapsed);
  printf("g\t%f\t%u\t%u\t%u\n", elapsed.tv_sec + elapsed.tv_usec / 1000000.,
	 counters[Lesser], counters[Equal], counters[Greater]);
}


int main()
{
  int value;
  for (value = 0; value < NUM_VALUES; ++value)
    values[value] = random() % 10;
  
  basis = 5;

  a();
  b();
  d();
  /* e(); */
  f();
  g();

  return 0;
}
