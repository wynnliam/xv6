#ifdef CS333_P5
#include "types.h"
#include "user.h"
#include "param.h"

int
main(int argc, char** argv)
{
  if(argc != 3)
  {
    printf(2, "Usage: chgrp GROUP TARGET\n");
    exit();
  }

  int group = atoi(argv[1]);
  int rc;

  if(MIN_GID_SIZE > group || MAX_GID_SIZE < group)
  {
    printf(2, "Invalid group\n");
    exit();
  }

  rc = chgrp(argv[2], group);

  if(rc == -1)
    printf(2, "Failed to change group\n");

  exit();
}

#endif
