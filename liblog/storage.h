#ifndef INCLUDE_liblog_storage_h
#define INCLUDE_liblog_storage_h

#include <sys/types.h>
#include "primitive.h"


const char *storageFilename();

void storeData(const void *, size_t);
void storeNull();
void storeString(const char *);
void storeValue(const char *, enum PrimitiveType, const void *, size_t);


#endif /* !INCLUDE_liblog_storage_h */
