#ifdef CS333_P5
#include "types.h"
#include "user.h"
int
main(int argc, char** argv)
{
  char* path;
  int mode;
  int rc;

  if(argc != 3)
  {
    printf(2, "Run like so: chmod PATH MODE\n");
    exit();
  }

  if(strlen(argv[1]) != 4)
  {
    printf(2, "Invalid mode\n");
    exit();
  }

  path = argv[2];
  mode = atoi(argv[1]);

  // Validate and set the correct representation for the mode
  if(0 > mode || mode > 1777)
  {
    printf(2, "Invalid mode\n");
    exit();
  }

  rc = chmod(path, mode);

  if(rc == -1)
    printf(2, "Failed to change mode\n");
  else if(rc == -2)
    printf(2, "Bad path\n");

  exit();
}

#endif
