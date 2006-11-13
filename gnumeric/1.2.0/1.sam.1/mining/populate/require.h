#ifndef INCLUDE_populate_require_h
#define INCLUDE_populate_require_h

class PgDatabase;


void require(bool, const PgDatabase &);
void require(bool, const char []);


#endif // !INCLUDE_populate_require_h
