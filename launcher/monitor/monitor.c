#include <Python.h>
#include <libbonobo.h>
#include "monitor.h"


/**********************************************************************/


static void sampler_monitor_init(SamplerMonitor *collector __attribute((unused)))
{
}


static void sampler_monitor_class_init(SamplerMonitorClass *klass __attribute((unused)))
{
}


BONOBO_TYPE_FUNC_FULL (SamplerMonitor, Bonobo_Unknown, BONOBO_TYPE_OBJECT, sampler_monitor);


/**********************************************************************/


SamplerMonitor *sampler_monitor_new()
{
  SamplerMonitor * const self = g_object_new(SAMPLER_TYPE_MONITOR, 0);
  return self;
}
