#ifdef CS333_P3P4

#include "types.h"
#include "user.h"
#include "param.h"

int
main(int argc, char** argv)
{
  if(argc < 3)
  {
    printf(1, "Bad args. Run as follows: ps PID PRIORITY\n");
    exit();
  }

  int pid = atoi(argv[1]);
  int priority = atoi(argv[2]);
  int rc = setpriority(pid, priority);

  if(rc == -1)
    printf(1, "ERROR: system call failed to get args\n");
  else if(rc == -2)
    printf(1, "ERROR: priority out of range. Range should be 0 to %d, but got %d\n", MAX_READY_QUEUES, priority);
  else if (rc == -3)
    printf(1, "ERROR: bad pid. PID: %d\n", pid);

  exit();
}

#endif
