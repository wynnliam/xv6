#ifdef CS333_P2
#include "types.h"
#include "user.h"

void print_total_ticks(uint total_ticks);

int
main(int argc, char** argv)
{
  int pid;
  uint start_ticks, total_ticks;

  if(argc <= 1)
  {
    printf(1, "ran in 0.00 seconds\n");
    exit();
  }

  pid = fork();

  // If we are the parent
  if(pid > 0)
  {
    start_ticks = uptime();
    pid = wait();
    total_ticks = uptime() - start_ticks;

    printf(1, "%s ran in ", argv[1]);
    print_total_ticks(total_ticks);
  }

  // If we are the child.
  else if(pid == 0)
  {
    exec(argv[1], &argv[1]);
    // Should never get here unless exec failed.
    printf(1, "%s is an invalid command\n", argv[1]);
  }

  // We have a problem
  else
    printf(1, "problem\n");


  exit();
}

void
print_total_ticks(uint total_ticks)
{
  uint sec, millisec;

  sec = total_ticks / 1000;
  millisec = total_ticks % 1000;

  printf(1, "%d.%d\n", sec, millisec);
}

#endif
