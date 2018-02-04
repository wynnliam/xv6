#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"

/*
	Takes a value in ticks and gets the seconds and milliseconds
	components of it.
*/
void convert_to_seconds(uint val, uint* sec, uint* dec);

int
main(int argc, char** argv)
{
  struct uproc* table;
  int max = 63;
  int read;

  if(argc > 1)
  {
    max = atoi(argv[1]);

    if(max <= 0)
      max = 4;
  }

  // The elapsed ticks in seconds, including the decimal component.
  uint elt_sec, elt_dec;
  // The total cpu ticks in second, with decimal component.
  uint cpu_sec, cpu_dec;

  table = (struct uproc*)malloc(sizeof(struct uproc) * max);

  read = getprocs(max, table);

  #ifndef CS333_P3P4
  printf(1, "%s	%s	%s	%s	%s	%s	%s			%s	%s\n", "id", "uid", "gid", "ppid", "elapsed time", "cpu time", "state", "size", "name");
  #else
  printf(1, "%s	%s	%s	%s	%s	%s	%s	%s		%s	%s\n", "id", "uid", "gid", "ppid", "prio", "elapsed time", "cpu time", "state", "size", "name");
  #endif

  int i;
  for(i = 0; i < read; ++i)
  {
    // Convert our values to seconds, but save the milliseconds.
    convert_to_seconds(table[i].elapsed_ticks, &elt_sec, &elt_dec);
    convert_to_seconds(table[i].cpu_total_ticks, &cpu_sec, &cpu_dec);

    #ifndef CS333_P3P4
    printf(1, "%d	%d	%d	%d	%d.%d		%d.%d		%s		%d	%s\n", table[i].pid,
		   table[i].uid, table[i].gid, table[i].ppid, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #else
    printf(1, "%d	%d	%d	%d	%d	%d.%d		%d.%d		%s	%d	%s\n", table[i].pid,
		   table[i].uid, table[i].gid, table[i].ppid, table[i].priority, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #endif
  }

  free(table);
  table = 0x0;

  exit();
}

void
convert_to_seconds(uint val, uint* sec, uint* dec)
{
	*sec = val / 1000;
	*dec = val % 1000;
	//*sec = val;
	//*dec = 0;
}

#endif
