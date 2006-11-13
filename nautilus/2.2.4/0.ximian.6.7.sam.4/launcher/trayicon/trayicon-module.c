#include <pygobject.h>
#include "trayicon-module.h"

 
DL_EXPORT(void) inittrayicon()
{
  PyObject *m, *d;
 
  init_pygobject();
 
  m = Py_InitModule("trayicon", trayicon_functions);
  d = PyModule_GetDict(m);
 
  trayicon_register_classes(d);
 
  if (PyErr_Occurred())
    Py_FatalError ("can't initialise module trayicon");
}
