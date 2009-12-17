#include <Python.h>
#include <orbit/orb-core/orbit-small.h>
#include <pygobject.h>
#include <pyorbit.h>


struct broken_ListenerObject
{
  PyObject_HEAD
  CORBA_Object object;
  GClosure *closure;
};


staticforward PyTypeObject broken_ListenerType;


static struct broken_ListenerObject *
broken_new_listener(PyObject *self, PyObject *args, PyObject *kwargs)
{
  static char *kwlist[] = {"object", "callback", 0};
  PyObject *object;
  PyObject *callback;

  if (!PyArg_ParseTupleAndKeywords(args, kwargs, "OO:broken.Listener.__init__", kwlist, &object, &callback))
    return 0;

  if (!PyObject_TypeCheck(object, &PyCORBA_Object_Type))
    {
      PyErr_SetString(PyExc_TypeError, "object argument must be a CORBA object");
      return 0;
    }

  if (!PyCallable_Check(callback))
    {
      PyErr_SetString(PyExc_TypeError, "callback argument must be callable");
      return 0;
    }

  struct broken_ListenerObject * const listener = PyObject_New(struct broken_ListenerObject, &broken_ListenerType);
  listener->object = ((PyCORBA_Object *) object)->objref;
  listener->closure = pyg_closure_new(callback, 0, 0);

  return listener;
}


static void broken_listener_dealloc(PyObject *self)
{
  PyObject_Del(self);
}


/**********************************************************************/


static PyTypeObject broken_ListenerType = {
  PyObject_HEAD_INIT(0)
  0,
  "Listener",
  sizeof(struct broken_ListenerObject),
  0,
  broken_listener_dealloc,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
};


static PyMethodDef broken_methods[] = {
  {"new_listener", (PyCFunction) broken_new_listener,
   METH_VARARGS | METH_KEYWORDS,
   "Create a new Listener object."},
  {0, 0, 0, 0}
};


DL_EXPORT(void) initbroken()
{
  init_pyorbit();
  init_pygobject();

  broken_ListenerType.ob_type = &PyType_Type;
  Py_InitModule("broken", broken_methods);
  fprintf(stderr, "broken module initialized\n");
}
