#include <libbonobo.h>
#include "collector.h"
#include "Sampler_ReportCollector.h"


static GObjectClass *parent_class;


static void unset_closure(PyObject **slot)
{
  Py_XDECREF(*slot);
  *slot = 0;
}


static int set_closure(PyObject **slot, PyObject *replacement)
{
  if (!PyCallable_Check(replacement))
    {
      PyErr_SetString(PyExc_TypeError, "parameter must be callable");
      return 1;
    }
  else
    {
      Py_XINCREF(replacement);
      Py_XDECREF(*slot);
      *slot = replacement;
      return 0;
    }
}


/**********************************************************************/


static CORBA_unsigned_long impl_sparsity(PortableServer_Servant servant,
					 CORBA_Environment *env)
{
  int result = 0;

  const SamplerReportCollector * const self = SAMPLER_REPORT_COLLECTOR(bonobo_object(servant));
  if (self && self->sparsity)
    {
      PyObject * const returned = PyEval_CallObject(self->sparsity, 0);
      if (returned)
	{
	  if (PyInt_Check(returned))
	    result = PyInt_AsLong(returned);

	  Py_DECREF(returned);
	}
    }

  return 0;
}


static void impl_reportUnit(PortableServer_Servant servant,
			    const Sampler_signature signature,
			    const Sampler_counts *counts,
			    CORBA_Environment *env)
{
  g_print("ReportCollector service: reportUnit\n");
  const SamplerReportCollector * const self = SAMPLER_REPORT_COLLECTOR(bonobo_object(servant));
  if (self && self->reportUnit)
    {
      PyObject * const tuple = PyTuple_New(counts->_length);

      int slot;
      for (slot = counts->_length; slot--; )
	{
	  PyObject * const boxed = Py_BuildValue("i", counts->_buffer[slot]);
	  /* check for allocation error: boxed == NULL */
	  PyTuple_SET_ITEM(tuple, slot, boxed);
	}

      PyObject * const arglist = Py_BuildValue("((iiii)O)",
					       signature[0],
					       signature[1],
					       signature[2],
					       signature[3],
					       tuple);
      Py_DECREF(tuple);

      if (arglist)
	{
	  PyObject * const result = PyEval_CallObject(self->reportUnit, arglist);
	  Py_DECREF(arglist);
	  Py_XDECREF(result);
	}
    }
}


static void impl_exitStatus(PortableServer_Servant servant,
			    const CORBA_octet status,
			    CORBA_Environment *env)
{
  const SamplerReportCollector * const self = SAMPLER_REPORT_COLLECTOR(bonobo_object(servant));
  if (self && self->exitStatus)
    {
      PyObject * const arglist = Py_BuildValue("(i)", status);
      if (arglist)
	{
	  PyObject * const result = PyEval_CallObject(self->exitStatus, arglist);
	  Py_DECREF(arglist);
	  Py_XDECREF(result);
	}
    }
}


static void impl_exitSignal(PortableServer_Servant servant,
			    const CORBA_octet signal,
			    CORBA_Environment *env)
{
  const SamplerReportCollector * const self = SAMPLER_REPORT_COLLECTOR(bonobo_object(servant));
  if (self && self->exitSignal)
    {
      PyObject * const arglist = Py_BuildValue("(i)", signal);
      if (arglist)
	{
	  PyObject * const result = PyEval_CallObject(self->exitSignal, arglist);
	  Py_DECREF(arglist);
	  Py_XDECREF(result);
	}
    }
}


/**********************************************************************/


static void sampler_report_collector_init(SamplerReportCollector *collector)
{
  g_print("instance init\n");
  collector->sparsity = 0;
  collector->reportUnit = 0;
  collector->exitStatus = 0;
  collector->exitSignal = 0;
}


static void sampler_report_collector_finalize(GObject *object)
{
  g_print("instance finalize\n");

  SamplerReportCollector * const self = SAMPLER_REPORT_COLLECTOR(object);
  unset_closure(&self->sparsity);
  unset_closure(&self->reportUnit);
  unset_closure(&self->exitStatus);
  unset_closure(&self->exitSignal);

  parent_class->finalize(object);
}


static void sampler_report_collector_class_init(SamplerReportCollectorClass *klass)
{
  GObjectClass *object_class = (GObjectClass *) klass;

  parent_class = g_type_class_peek_parent(klass);
  object_class->finalize = sampler_report_collector_finalize;

  POA_Sampler_ReportCollector__epv *epv = &klass->epv;
  epv->sparsity = impl_sparsity;
  epv->reportUnit = impl_reportUnit;
  epv->exitStatus = impl_exitStatus;
  epv->exitSignal = impl_exitSignal;
}


BONOBO_TYPE_FUNC_FULL (SamplerReportCollector, Sampler_ReportCollector, BONOBO_TYPE_OBJECT, sampler_report_collector);


/**********************************************************************/


SamplerReportCollector *sampler_report_collector_new(PyObject *sparsity,
						     PyObject *reportUnit,
						     PyObject *exitStatus,
						     PyObject *exitSignal)
{
  SamplerReportCollector * const self = g_object_new(SAMPLER_TYPE_REPORT_COLLECTOR, 0);

  int bad = 0;
  bad |= set_closure(&self->sparsity, sparsity);
  bad |= set_closure(&self->reportUnit, reportUnit);
  bad |= set_closure(&self->exitStatus, exitStatus);
  bad |= set_closure(&self->exitSignal, exitSignal);

  return bad ? 0 : self;
}
