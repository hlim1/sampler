#ifndef INCLUDE_report_collector_h
#define INCLUDE_report_collector_h

#include <bonobo/bonobo-object.h>
#include <Python.h>
#include "Sampler_ReportCollector.h"

G_BEGIN_DECLS


#define SAMPLER_TYPE_REPORT_COLLECTOR		(sampler_report_collector_get_type())
#define SAMPLER_REPORT_COLLECTOR(o)		(G_TYPE_CHECK_INSTANCE_CAST((o), SAMPLER_TYPE_REPORT_COLLECTOR, SamplerReportCollector))
#define SAMPLER_REPORT_COLLECTOR_CLASS(k)	(G_TYPE_CHECK_CASS_CAST((k),     SAMPLER_TYPE_REPORT_COLLECTOR, SamplerReportCollectorClass))
#define IS_SAMPLER_REPORT_COLLECTOR(o)		(G_TYPE_CHECK_INSTANCE_TYPE((o), SAMPLER_TYPE_REPORT_COLLECTOR))
#define IS_SAMPLER_REPORT_COLLECTOR_CLASS(k)	(G_TYPE_CHECK_CLASS_TYPE((k),    SAMPLER_TYPE_REPORT_COLLECTOR))
#define SAMPLER_REPORT_COLLECTOR_GET_CLASS(o)	(G_TYPE_INSTANCE_GET_CLASS((o),  SAMPLER_TYPE_REPORT_COLLECTOR, SamplerReportCollectorClass))


struct _SamplerReportCollector {
  BonoboObject parent;
  PyObject *sparsity;
  PyObject *reportUnit;
  PyObject *exitStatus;
  PyObject *exitSignal;
};

typedef struct _SamplerReportCollector SamplerReportCollector;


struct _SamplerReportCollectorClass {
  BonoboObjectClass parent_class;
  POA_Sampler_ReportCollector__epv epv;
};

typedef struct _SamplerReportCollectorClass SamplerReportCollectorClass;


GType sampler_report_collector_get_type();

SamplerReportCollector *sampler_report_collector_new(PyObject *sparsity,
						     PyObject *reportUnit,
						     PyObject *exitStatus,
						     PyObject *exitSignal);


#endif /* !INCLUDE_report_collector_h */
