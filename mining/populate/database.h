#ifndef INCLUDE_populate_database_h
#define INCLUDE_populate_database_h

#include <libpq++/pgdatabase.h>


extern PgDatabase database;

void require(bool);


#endif // !INCLUDE_populate_database_h
