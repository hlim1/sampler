#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include "library.h"


static void dlcheck()
{
  const char * const message = dlerror();
  if (message)
    {
      fputs(message, stderr);
      fputc('\n', stderr);
      exit(3);
    }
}


int main()
{
  void * const plugin = dlopen("./plugin.so", RTLD_LAZY);
  dlcheck();

  {
    void (* const function)() = (void (*)()) dlsym(plugin, "function");
    dlcheck();
    function();
  }
  
  libraryFunction();

  dlclose(plugin);
  dlcheck();
  return 0;
}
