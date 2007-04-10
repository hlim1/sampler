#ifndef INCLUDE_monitor_module_h
#define INCLUDE_monitor_module_h

#include <Python.h>


void monitor_register_classes(PyObject *); 
extern PyMethodDef monitor_functions[];


#endif /* !INCLUDE_monitor_module_h */
