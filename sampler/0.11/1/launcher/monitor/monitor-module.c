#include <pygobject.h>
#include "monitor-module.h"

 
DL_EXPORT(void) initmonitor()
{
  init_pygobject ();
 
  PyObject * const module = Py_InitModule ("monitor", monitor_functions);
  PyObject * const dictionary = PyModule_GetDict(module);
  monitor_register_classes(dictionary);
 
  if (PyErr_Occurred ())
    Py_FatalError ("can't initialise module monitor");
}
