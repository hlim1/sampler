#ifndef INCLUDE_uploader_h
#define INCLUDE_uploader_h

#include <bonobo/bonobo-object.h>
#include "Sampler_Uploader.h"

G_BEGIN_DECLS


#define TYPE_UPLOADER		(uploader_get_type())
#define UPLOADER(o)		(G_TYPE_CHECK_INSTANCE_CAST((o), TYPE_UPLOADER, Uploader))
#define UPLOADER_CLASS(k)	(G_TYPE_CHECK_CASS_CAST((k),     TYPE_UPLOADER, UploaderClass))
#define IS_UPLOADER(o)		(G_TYPE_CHECK_INSTANCE_TYPE((o), TYPE_UPLOADER))
#define IS_UPLOADER_CLASS(k)	(G_TYPE_CHECK_CLASS_TYPE((k),    TYPE_UPLOADER))
#define UPLOADER_GET_CLASS(o)	(G_TYPE_INSTANCE_GET_CLASS((o),  TYPE_UPLOADER, UploaderClass))


typedef struct {
  BonoboObject parent;
  char *title;
} Uploader;


typedef struct
{
  BonoboObjectClass parent_class;
  POA_Sampler_Uploader__epv epv;
} UploaderClass;


GType uploader_get_type();


#endif /* !INCLUDE_uploader_h */
