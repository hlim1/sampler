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

  Py_XINCREF(replacement);
  Py_XDECREF(*slot);
  *slot = replacement;
  return 0;
}


/**********************************************************************/


static void impl_addHeader(PortableServer_Servant servant,
			   const CORBA_char *name,
			   const CORBA_char *value,
			   CORBA_Environment *env)
{
  g_print("ReportCollector service: addHeader\n");
  const SamplerReportCollector * const self = SAMPLER_REPORT_COLLECTOR(bonobo_object(servant));
  if (!self) return;
  if (!self->addHeader) return;
  
  PyObject * const arglist = Py_BuildValue("(ss)", name, value);
  if (!arglist) return;

  PyObject * const result = PyEval_CallObject(self->addHeader, arglist);
  Py_DECREF(arglist);
  Py_XDECREF(result);
}


static void impl_addReport(PortableServer_Servant servant,
			   const CORBA_char *name,
			   const CORBA_char *contents,
			   CORBA_Environment *env)
{
  g_print("ReportCollector service: addReport\n");
  const SamplerReportCollector * const self = SAMPLER_REPORT_COLLECTOR(bonobo_object(servant));
  if (!self) return;
  if (!self->addReport) return;

  PyObject * const arglist = Py_BuildValue("(ss)", name, contents);
  if (!arglist) return;
  
  PyObject * const result = PyEval_CallObject(self->addReport, arglist);
  Py_DECREF(arglist);
  Py_XDECREF(result);
}


static void impl_submit(PortableServer_Servant servant,
			const CORBA_char *url,
			CORBA_Environment *env)
{
  const SamplerReportCollector * const self = SAMPLER_REPORT_COLLECTOR(bonobo_object(servant));
  if (!self) return;
  if (!self->submit) return;

  PyObject * const arglist = Py_BuildValue("(s)", url);
  if (!arglist) return;

  PyObject * const result = PyEval_CallObject(self->submit, arglist);
  Py_DECREF(arglist);
  Py_XDECREF(result);
}


/**********************************************************************/


static void sampler_report_collector_init(SamplerReportCollector *collector)
{
  g_print("instance init\n");
  collector->addHeader = 0;
  collector->addReport = 0;
  collector->submit = 0;
}


static void sampler_report_collector_finalize(GObject *object)
{
  g_print("instance finalize\n");

  SamplerReportCollector * const self = SAMPLER_REPORT_COLLECTOR(object);
  unset_closure(&self->addHeader);
  unset_closure(&self->addReport);
  unset_closure(&self->submit);

  parent_class->finalize(object);
}


static void sampler_report_collector_class_init(SamplerReportCollectorClass *klass)
{
  GObjectClass *object_class = (GObjectClass *) klass;

  parent_class = g_type_class_peek_parent(klass);
  object_class->finalize = sampler_report_collector_finalize;

  POA_Sampler_ReportCollector__epv *epv = &klass->epv;
  epv->addHeader = impl_addHeader;
  epv->addReport = impl_addReport;
  epv->submit = impl_submit;
}


BONOBO_TYPE_FUNC_FULL (SamplerReportCollector, Sampler_ReportCollector, BONOBO_TYPE_OBJECT, sampler_report_collector);


/**********************************************************************/


SamplerReportCollector *sampler_report_collector_new(PyObject *addHeader,
						     PyObject *addReport,
						     PyObject *submit)
{
  SamplerReportCollector * const self = g_object_new(SAMPLER_TYPE_REPORT_COLLECTOR, 0);

  int bad = 0;
  bad |= set_closure(&self->addHeader, addHeader);
  bad |= set_closure(&self->addReport, addReport);
  bad |= set_closure(&self->submit, submit);

  g_print("instance construction complete: bad == %d\n", bad);
  return bad ? 0 : self;
}
