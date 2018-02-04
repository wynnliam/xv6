#ifdef CS333_P5
#include "types.h"
#include "user.h"
#include "param.h"

int
main(int argc, char** argv)
{
  if(argc != 3)
  {
    printf(2, "Usage: chown OWNER TARGET\n");
    exit();
  }

  int owner = atoi(argv[1]);
  int rc;

  if(MIN_UID_SIZE > owner || MAX_UID_SIZE < owner)
  {
    printf(2, "Invalid uid\n");
    exit();
  }

  rc = chown(argv[2], owner);

  if(rc == -1)
    printf(2, "Failed to change ownership\n");

  exit();
}

#endif
