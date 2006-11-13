#ifndef INCLUDE_populate_File_h
#define INCLUDE_populate_File_h

#include <iosfwd>
#include <string>

class PgDatabase;


struct File
{
public:
  explicit File(const string &);

  void upload(PgDatabase &) const;
  const string &id() const;

  friend bool operator < (const File &a, const File &b);

private:
  const string name;
};


////////////////////////////////////////////////////////////////////////


inline File::File(const string &name)
  : name(name)
{
}


#endif // !INCLUDE_populate_File_h
