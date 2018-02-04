#ifdef CS333_P3P4

#include "types.h"
#include "user.h"

int
main(int argc, char** argv)
{
  int n = 5;
  int pid;

  int i;
  for(i = 0; i < n; ++i)
  {
    pid = fork();

    if(pid == 0)
    {
      while(1) sleep(1000000);
      break;
    }

    if(pid < 0)
      break;
  }

  exit();
}

#endif
