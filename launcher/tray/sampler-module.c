#include <pygobject.h>

void sampler_register_classes(PyObject *); 
extern PyMethodDef sampler_functions[];
 
DL_EXPORT(void)
initsampler(void)
{
    PyObject *m, *d;
 
    init_pygobject ();
 
    m = Py_InitModule ("sampler", sampler_functions);
    d = PyModule_GetDict (m);
 
    sampler_register_classes (d);
 
    if (PyErr_Occurred ()) {
        Py_FatalError ("can't initialise module sampler");
    }
}
