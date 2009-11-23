#include <dlfcn.h>
#include <stdio.h>


int (*subtract_ptr)(int a, int b);


void heartbeat()
{
}


int subtract(int a, int b)
{
  if (subtract_ptr)
    return subtract_ptr(a, b);
  else
    return a - b;
}


int main()
{
  printf("7 - 2 == %d\n", subtract(7, 2));
  return 0;
}


static void install_patches() __attribute__((constructor));

static void install_patches()
{
  void * const handle = dlopen(0, RTLD_LAZY);
  subtract_ptr = (int (*)(int, int)) dlsym(handle, "subtract_replacement");
  dlclose(handle);
}
