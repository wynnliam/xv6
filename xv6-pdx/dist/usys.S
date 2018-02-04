#include "syscall.h"
#include "traps.h"

// Contains the system calls made available by the kernel.
// In addition, we have code for actually making the system
// calls.

// The names come from syscall.h. This function will take
// a name like "date", add "SYS_" to the front to create
// "SYS_date", and then invokes an interrupt to perform
// a system call. Note that we move the number associated
// with SYS_date or whatever into %eax. This is how the OS
// knows what function to invoke. I believe syscall in
// in syscall.c handles this.

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(halt)
SYSCALL(date)
SYSCALL(getuid)
SYSCALL(getgid)
SYSCALL(getppid)
SYSCALL(setuid)
SYSCALL(setgid)
SYSCALL(getprocs)
SYSCALL(setpriority)
SYSCALL(chmod)
SYSCALL(chown)
SYSCALL(chgrp)
