#ifndef INCLUDE_uploader_h
#define INCLUDE_uploader_h

#include <bonobo/bonobo-object.h>
#include "Sampler_Uploader.h"

G_BEGIN_DECLS


#define SAMPLER_TYPE_UPLOADER		(sampler_uploader_get_type())
#define SAMPLER_UPLOADER(o)		(G_TYPE_CHECK_INSTANCE_CAST((o), SAMPLER_TYPE_UPLOADER, SamplerUploader))
#define SAMPLER_UPLOADER_CLASS(k)	(G_TYPE_CHECK_CASS_CAST((k),     SAMPLER_TYPE_UPLOADER, SamplerUploaderClass))
#define IS_SAMPLER_UPLOADER(o)		(G_TYPE_CHECK_INSTANCE_TYPE((o), SAMPLER_TYPE_UPLOADER))
#define IS_SAMPLER_UPLOADER_CLASS(k)	(G_TYPE_CHECK_CLASS_TYPE((k),    SAMPLER_TYPE_UPLOADER))
#define SAMPLER_UPLOADER_GET_CLASS(o)	(G_TYPE_INSTANCE_GET_CLASS((o),  SAMPLER_TYPE_UPLOADER, SamplerUploaderClass))


struct _SamplerUploader {
  BonoboObject parent;
  GClosure *increment;
  GClosure *decrement;
};

typedef struct _SamplerUploader SamplerUploader;


struct _SamplerUploaderClass {
  BonoboObjectClass parent_class;
  POA_Sampler_Uploader__epv epv;
};

typedef struct _SamplerUploaderClass SamplerUploaderClass;


GType sampler_uploader_get_type();

SamplerUploader *sampler_uploader_new();

void sampler_uploader_set_closures(SamplerUploader *, GClosure *increment, GClosure *decrement);


#endif /* !INCLUDE_uploader_h */
