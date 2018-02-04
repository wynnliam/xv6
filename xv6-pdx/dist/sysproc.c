#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#ifdef CS333_P2
#include "uproc.h"

extern int get_active_procs(uint, struct uproc*);
#endif

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
}

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
  uint xticks;
  
  xticks = ticks;
  return xticks;
}

//Turn of the computer
int
sys_halt(void){
  cprintf("Shutting down ...\n");
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}

#ifdef CS333_P1
int
sys_date(void)
{
	// This stores the date itself.
	struct rtcdate* date;

	// Grab the date argument passed in. If this fails, return -1.
	if(argptr(0, (void*)&date, sizeof(struct rtcdate) < 0))
		return -1;

	cmostime(date);

	return 0;
}
#endif

#ifdef CS333_P2
int
sys_getuid(void)
{
	// If the proc is bad, return an error.
	if(!proc)
		return -1;

	// The uid is an uint, but value from 0 to 3767
	return (int)proc->uid;
}

int
sys_getgid(void)
{
	return (int)proc->gid;
}

int
sys_getppid(void)
{
	int result;

	// As per the requirements, the PPID of process 1 is 1 as well.
	if(!proc->parent)
		result = 1;
	else
		result = (int)proc->parent->pid;

	return result;
}

int
sys_setuid(void)
{
	// Stores the argument that the user gives us.
	uint val;

	if(argptr(0, (void*)&val, sizeof(uint)) == -1)
		return -1;

	// Enforces the bounds that a UID must be.
	// I recognize that the lower bound is probably
	// uneccessary since we're dealing in unsigned ints,
	// but on the other hand, it prevents undeterministic
	// related to giving a uint a negative value.
	if(MIN_UID_SIZE > val || val > MAX_UID_SIZE)
		return -1;

	proc->uid = val;

	return 0;
}

int
sys_setgid(void)
{
	uint val;

	if(argptr(0, (void*)&val, sizeof(uint)) == -1)
		return -1;
	if(MIN_GID_SIZE > val || val > MAX_GID_SIZE)
		return -1;

	proc->gid = val;

	return 0;
}

int
sys_getprocs(void)
{
	// Maximum number of processes to read in.
	uint max;
	// Where to store the process data.
	struct uproc* table;

	if(argptr(0, (void*)&max, sizeof(uint)) == -1)
		return -1;
	if(argptr(1, (void*)&table, sizeof(struct uproc*)) == -1)
		return -1;

	return get_active_procs(max, table);
}
#endif

#ifdef CS333_P3P4
int
sys_setpriority(void)
{
  int pid, priority;
  int rc;

  if(argint(0, &pid) == -1)
    return -1;
  else if(argint(1, &priority) == -1)
    return -1;

  rc = dosetpriority(pid, priority);

  // Priority out of range
  if(rc == -1)
    return -2;
  // Failed to find active process with
  // pid.
  else if(rc == 0)
    return -3;

  return 0;
}
#endif
