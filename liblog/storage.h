#ifndef INCLUDE_liblog_storage_h
#define INCLUDE_liblog_storage_h

#include <sys/types.h>
#include "primitive.h"


void storeInitialize(const char *);
void storeShutdown();

void storeData(const void *, size_t);
void storeByte(char);
void storeString(const char *);
void storeValue(const char *, enum PrimitiveType, const void *, size_t);

extern inline
void storeNull()
{
  storeByte(0);
}


#endif /* !INCLUDE_liblog_storage_h */
