#include "types.h"
#include "user.h"

int
main()
{
  int additional_procs = 12;
  // Account for PS
  int n = additional_procs + 1;
  int pid;
  char* args[] = { "ps", "16" };

  int i;
  for(i = 0; i < additional_procs; ++i)
  {
    pid = fork();
    if(pid == 0)
    {
      sleep(20000);
      exit();
    }
  }

  pid = fork();

  if(pid == 0)
  {
    exec("ps", args);
    exit();
  }

  while(n > 0)
  {
    pid = wait();
    --n;
  }

  exit();
}
