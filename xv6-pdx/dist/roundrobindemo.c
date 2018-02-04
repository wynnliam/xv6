#ifdef CS333_P3P4

#include "types.h"
#include "user.h"

int
main(int argc, char** argv)
{
  int pid = fork();

  if(pid > 0)
  {
    while(1)
    {
      printf(1, "Parent turn!\n");
      sleep(1000);
    }
  }

  else if(pid == 0)
  {
    sleep(1000);
    while(1)
    {
      printf(1, "Child turn!\n");
      sleep(1000);
    }
  }

  exit();
}

#endif
