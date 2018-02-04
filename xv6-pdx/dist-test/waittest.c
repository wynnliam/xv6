#ifdef CS333_P3P4

#include "types.h"
#include "user.h"

int
main(int argc, char** argv)
{
  int pid = fork();

  if(pid == 0)
  {
    sleep(1000);
    exit();
  }

  else if(pid > 0)
  {
    sleep(2000);
    while(wait() == -1);
    sleep(2000);
  }

  exit();
}

#endif
