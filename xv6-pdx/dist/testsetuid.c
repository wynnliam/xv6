#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int rc;

  printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  printf(1, "***** In %s: my gid is %d\n\n", argv[0], getgid());
  printf(1, "***** In %s: my ppid is %d\n\n", argv[0], getppid());

  rc = setuid(324);
  if(rc == 0)
    printf(1, "New uid: %d\n", getuid());
  else
    printf(1, "Failed to set uid\n");

  rc = setuid(-1);
  if(rc == -1)
    printf(1, "Successfully kept uid from being < 0!\n");
  else
    printf(1, "Something's not right with setuid. Was able to set it to < 0\n");

  rc = setuid(32768);
  if(rc == -1)
    printf(1, "Successfully kept uid from being > 32767!\n");
  else
    printf(1, "Something's not right with setuid. Was able to set it to > 32767\n");

  rc = setgid(1776);
  if(rc == 0)
    printf(1, "New gid: %d\n", getgid());
  else
    printf(1, "Failed to set gid\n");

  rc = setgid(-1);
  if(rc == -1)
    printf(1, "Successfully kept gid from being < 0!\n");
  else
    printf(1, "Something's not right with setgid. Was able to set it to < 0\n");

  rc = setuid(32768);
  if(rc == -1)
    printf(1, "Successfully kept gid from being > 32767!\n");
  else
    printf(1, "Something's not right with setgid. Was able to set it to > 32767\n");

  exit();
}
