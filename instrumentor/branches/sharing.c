#include <dlfcn.h>
#include <stdio.h>
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
    void (* const function)(int) = (void (*)(int)) dlsym(plugin, "function");
    dlcheck();
    function(1);
  }
  
  libraryFunction(1);

  dlclose(plugin);
  dlcheck();
  return 0;
}
