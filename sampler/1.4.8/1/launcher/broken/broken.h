#ifndef INCLUDE_broken_listener_h
#define INCLUDE_broken_listener_h

#include <Python.h>
#include <orbit/orb-core/orbit-small.h>

G_BEGIN_DECLS


#define BROKEN_TYPE_LISTENER		(broken_listener_get_type())
#define BROKEN_LISTENER(o)		(G_TYPE_CHECK_INSTANCE_CAST((o), BROKEN_TYPE_LISTENER, BrokenListener))
#define BROKEN_LISTENER_CLASS(k)	(G_TYPE_CHECK_CASS_CAST((k),     BROKEN_TYPE_LISTENER, BrokenListenerClass))
#define IS_BROKEN_LISTENER(o)		(G_TYPE_CHECK_INSTANCE_TYPE((o), BROKEN_TYPE_LISTENER))
#define IS_BROKEN_LISTENER_CLASS(k)	(G_TYPE_CHECK_CLASS_TYPE((k),    BROKEN_TYPE_LISTENER))
#define BROKEN_LISTENER_GET_CLASS(o)	(G_TYPE_INSTANCE_GET_CLASS((o),  BROKEN_TYPE_LISTENER, BrokenListenerClass))


struct _BrokenListener {
  GObject parent;
  CORBA_Object object;
  GClosure *callback;
};

typedef struct _BrokenListener BrokenListener;


struct _BrokenListenerClass {
  GObjectClass parent_class;
};

typedef struct _BrokenListenerClass BrokenListenerClass;


GType broken_listener_get_type();

BrokenListener *broken_listener_new(CORBA_Object object, GClosure *closure);


#endif /* !INCLUDE_broken_listener_h */
