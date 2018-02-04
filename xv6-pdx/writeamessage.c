#ifdef CS333_P5
#include "types.h"
#include "user.h"
#include "fcntl.h"

int
main()
{
  int fd;
  char* message = "Hello there";

  fd = open("coolfile.txt", O_CREATE | O_WRONLY);
  write(fd, message, 11);

  exit();
}

#endif
