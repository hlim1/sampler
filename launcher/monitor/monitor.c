#include <libbonobo.h>
#include "monitor.h"
#include "Sampler_Monitor.h"


/**********************************************************************/


static void sampler_monitor_init(SamplerMonitor *collector)
{
}


static void sampler_monitor_class_init(SamplerMonitorClass *klass)
{
}


BONOBO_TYPE_FUNC_FULL (SamplerMonitor, Sampler_Monitor, BONOBO_TYPE_OBJECT, sampler_monitor);


/**********************************************************************/


SamplerMonitor *sampler_monitor_new()
{
  SamplerMonitor * const self = g_object_new(SAMPLER_TYPE_MONITOR, 0);
  return self;
}
