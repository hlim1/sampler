#ifndef INCLUDE_monitor_h
#define INCLUDE_monitor_h

#include <bonobo/bonobo-object.h>
#include <Python.h>
#include "Sampler_Monitor.h"

G_BEGIN_DECLS


#define SAMPLER_TYPE_MONITOR		(sampler_monitor_get_type())
#define SAMPLER_MONITOR(o)		(G_TYPE_CHECK_INSTANCE_CAST((o), SAMPLER_TYPE_MONITOR, SamplerMonitor))
#define SAMPLER_MONITOR_CLASS(k)	(G_TYPE_CHECK_CASS_CAST((k),     SAMPLER_TYPE_MONITOR, SamplerMonitorClass))
#define IS_SAMPLER_MONITOR(o)		(G_TYPE_CHECK_INSTANCE_TYPE((o), SAMPLER_TYPE_MONITOR))
#define IS_SAMPLER_MONITOR_CLASS(k)	(G_TYPE_CHECK_CLASS_TYPE((k),    SAMPLER_TYPE_MONITOR))
#define SAMPLER_MONITOR_GET_CLASS(o)	(G_TYPE_INSTANCE_GET_CLASS((o),  SAMPLER_TYPE_MONITOR, SamplerMonitorClass))


struct _SamplerMonitor {
  BonoboObject parent;
};

typedef struct _SamplerMonitor SamplerMonitor;


struct _SamplerMonitorClass {
  BonoboObjectClass parent_class;
  POA_Sampler_Monitor__epv epv;
};

typedef struct _SamplerMonitorClass SamplerMonitorClass;


GType sampler_monitor_get_type();

SamplerMonitor *sampler_monitor_new();


#endif /* !INCLUDE_monitor_h */
