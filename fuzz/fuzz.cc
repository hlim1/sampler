#include <fcntl.h>
#include <iostream>
#include <sstream>
#include <sys/mman.h>
#include <unistd.h>


static unsigned parse(const char *text)
{
  std::istringstream stream(text);
  unsigned result;
  stream >> result;
  assert(stream.good());
  assert(stream.peek() == EOF);
  return result;
}


int main(int argc, char *argv[])
{
  if (argc != 4)
    {
      std::cerr << "usage: " << argv[0] << " <seed> <megs> <outfile>" << std::endl;
      return 2;
    }

  srand48(parse(argv[1]));
  const size_t bytes = parse(argv[2]) * 1024 * 1024;
  const int fd = open(argv[3], O_RDWR | O_CREAT, 0666);

  ftruncate(fd, bytes);
  int32_t * const map = (int32_t *) mmap(0, bytes, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  
  const unsigned words = bytes / sizeof(int32_t);
  for (unsigned word = 0; word < words; ++word)
    map[word] = mrand48();
      
  munmap(map, bytes);
  close(fd);
  return 0;
}
