#ifndef INCLUDE_populate_Progress_h
#define INCLUDE_populate_Progress_h

#include <string>


class Progress
{
public:
  Progress(const string &, unsigned);
  ~Progress();
  
  void bump();

private:
  const string description;
  const unsigned total;
  unsigned current;
};


#endif
