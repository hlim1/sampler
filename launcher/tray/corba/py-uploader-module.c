#include <pygobject.h>

void uploader_register_classes(PyObject *); 
extern PyMethodDef uploader_functions[];
 
DL_EXPORT(void)
inituploader(void)
{
    PyObject *m, *d;
 
    init_pygobject ();
 
    m = Py_InitModule ("uploader", uploader_functions);
    d = PyModule_GetDict (m);
 
    uploader_register_classes (d);
 
    if (PyErr_Occurred ()) {
        Py_FatalError ("can't initialise module uploader");
    }
}
