#ifdef CS333_P3P4

#include "types.h"
#include "user.h"

int
main(int argc, char** argv)
{
  printf(1, "zombie free\n");

  int cpid[100];
  int index = 0;

  int pid;
  do
  {
    pid = fork();

    if(pid > 0)
    {
      cpid[index] = pid;
      ++index;
    }

    else if(pid == 0)
      while(1);
  } while(pid >= 0);

  printf(1, "Total children made: %d\n", index + 1);

  sleep(4000);

  int i;
  for(i = 0; i <= index; ++i)
  {
    kill(cpid[i]);
    printf(1, "Killed child %d\n", cpid[i]);
    while(wait() == -1);
  }

  exit();
}

#endif
