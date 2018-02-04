#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#ifdef CS333_P2
#include "uproc.h"
#endif

#ifdef CS333_P3P4

/*
  Stores the head of every process list. Each list
  corresponds to a state a process can be in.

  All processes are in one and only one state. God help
  me if a process is in two of these or more.
*/
struct StateLists
{
  // All processes in this list are RUNNABLE, and can
  // be scheduled by the scheduler to run. We include
  // An array of these to denote the different priorities
  // each process can have.
  struct proc* ready[MAX_READY_QUEUES + 1];
  // All processes here are in the UNUSED state, and
  // can be allocated into a new process.
  struct proc* free;
  // All processes here are in the SLEEPING state, and
  // are waiting on something like IO.
  struct proc* sleep;
  // All processes here are in the ZOMBIE state, and are
  // waiting to be reaped by their parent or init.
  struct proc* zombie;
  // All processes here are in the RUNNING state, and
  // are being executed by a CPU. At most, there can
  // be NCPU number of processes here (see param.h)
  struct proc* running;
  // All processes here are in the EMBRYO state, and
  // are being initialized.
  struct proc* embryo;
};
#endif

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  #ifdef CS333_P3P4
  // Stores the processes in their respective lists.
  struct StateLists pLists;
  // The ticks we need to reach to promote all processes
  // in their priority.
  uint PromoteAtTicks;
  #endif
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

#ifdef CS333_P3P4
void
plistinsert(struct proc* p, struct proc** list)
{
  if(!p || !list)
    panic("Bad insert");

  struct proc* curr = *list;

  // Special case: the list is empty)
  if(!curr)
  {
    p->next = *list;
    *list = p;
    return;
  }

  while(curr->next)
    curr = curr->next;

  curr->next = p;
  p->next = 0x0;
}

void
plistremove(struct proc* p, struct proc** list)
{
  // If p is not in the list, we will panic
  if(!p || !list)
    panic("Bad remove!");

  assertinlist(p, *list);

  struct proc* prev;
  struct proc* curr;

  prev = 0x0;
  curr = *list;

  while(curr)
  {
    if(curr == p)
    {
      if(prev == 0x0)
        *list = (*list)->next;
      else
        prev->next = curr->next;

      break;
    }

    else
    {
      prev = curr;
      curr = curr->next;
    }
  }
}

void
assertinlist(struct proc* proc, struct proc* list)
{
  struct proc* curr = list;

  while(curr)
  {
    if(curr == proc)
      return;
    else
      curr = curr->next;
  }

  panic("Proc not in list!");
}

#endif

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  #ifndef CS333_P3P4
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;
  #else
  acquire(&ptable.lock);
  //If there is an available process
  if(ptable.pLists.free)
  {
    p = ptable.pLists.free;
    plistremove(p, &ptable.pLists.free);

    goto found;
  }

  else
  {
    // No procs can be allocated, so release.
    release(&ptable.lock);
    return 0;
  }
  #endif

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  // Add the proc to the embryo list
  #ifdef CS333_P3P4
  plistinsert(p, &ptable.pLists.embryo);
  #endif

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3P4
    acquire(&ptable.lock);

    // Remove p from embryo list and add to free list again
    plistremove(p, &ptable.pLists.embryo);
    plistinsert(p, &ptable.pLists.free);

    release(&ptable.lock);
    #endif

    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  #ifdef CS333_P1
  // Initialize the process's start_ticks to be the global tick count.
  // This gives us a timestamp of WHEN the process starts. In addition,
  // when the process ends, we can calculate how long the process ran.
  p->start_ticks = ticks;
  #endif

  #ifdef CS333_P2
  p->cpu_ticks_total = 0;
  p->cpu_ticks_in = 0;
  #endif

  #ifdef CS333_P3P4
  p->priority = 0;
  p->budget = MAX_BUDGET;
  #endif

  return p;
}

// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
 
  #ifdef CS333_P3P4
  initproclists();
  #endif
 
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // Note that p is the first user process, so we will
  // give them the default uid and gid
  #ifdef CS333_P2
  p->uid = DEFAULT_UID;
  p->gid = DEFAULT_GID;
  #endif

  #ifdef CS333_P3P4
  // Remove p from the embryo list and add to
  // the ready list

  acquire(&ptable.lock);

  // Remove p from the embryo list and add to ready list.
  plistremove(p, &ptable.pLists.embryo);
  p->state = RUNNABLE;
  plistinsert(p, &(ptable.pLists.ready[p->priority]));

  // Initialize the ticks to promote at.
  ptable.PromoteAtTicks = TICKS_TO_PROMOTE;

  release(&ptable.lock);
  #else
  acquire(&ptable.lock);
  p->state = RUNNABLE;
  release(&ptable.lock);
  #endif
}

#ifdef CS333_P3P4
void
initproclists(void)
{
  acquire(&ptable.lock);

  // At this point, we have no processes in any list.
  // We will set all the lists to empty.

  //ptable.pLists.ready = 0x0;

  int i;
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
    ptable.pLists.ready[i] = 0x0;

  ptable.pLists.free = 0x0;
  ptable.pLists.sleep = 0x0;
  ptable.pLists.zombie = 0x0;
  ptable.pLists.running = 0x0;
  ptable.pLists.embryo = 0x0;

  /*
    At this point, we don't have any processes anywhere.
    They should all be in the free stage at first. This way,
    when we run allocproc() it will work just fine
  */
  for(i = 0; i < NPROC; ++i)
  {
    ptable.proc[i].state = UNUSED;
    plistinsert(&ptable.proc[i], &ptable.pLists.free);
  }


  release(&ptable.lock);
}
#endif

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p. If this fails, remove np from
  // the embryo list if this operation fails.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;

    #ifdef CS333_P3P4
    acquire(&ptable.lock);
    plistremove(np, &ptable.pLists.embryo);
    np->state = UNUSED;
    plistinsert(np, &ptable.pLists.free);
    release(&ptable.lock);
    #else
    acquire(&ptable.lock);
    np->state = UNUSED;
    release(&ptable.lock);
    #endif

    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  #ifdef CS333_P2
  np->uid = proc->uid;
  np->gid = proc->gid;
  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  plistremove(np, &ptable.pLists.embryo);
  np->state = RUNNABLE;
  plistinsert(np, &(ptable.pLists.ready[np->priority]));
  release(&ptable.lock);
  #else
  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);
  #endif
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#else
void
exit(void)
{
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  // This will require traversing every list looking for
  // processes whose parent is proc.
  int i;
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
    adoptallchildren(proc, ptable.pLists.ready[i]);
  adoptallchildren(proc, ptable.pLists.running);
  adoptallchildren(proc, ptable.pLists.sleep);
  adoptallchildren(proc, ptable.pLists.zombie);
  adoptallchildren(proc, ptable.pLists.embryo);

  // Jump into the scheduler, never to return.
  plistremove(proc, &ptable.pLists.running);
  proc->state = ZOMBIE;
  plistinsert(proc, &ptable.pLists.zombie);
  sched();
  panic("zombie exit");
}
#endif

#ifdef CS333_P3P4
void
adoptallchildren(struct proc* parent, struct proc* list)
{
  struct proc* p;

  p = list;
  while(p)
  {
    if(p->parent == proc)
    {
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }

    p = p->next;
  }
}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = havechildren(proc, ptable.pLists.running) ||
               havechildren(proc, ptable.pLists.zombie) ||
               havechildren(proc, ptable.pLists.embryo) ||
               havechildren(proc, ptable.pLists.sleep);

    // If we do not find any children, scan the ready lists
    // to find a kid.
    if(havekids == 0)
    {
      int i;
      for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
      {
        havekids = havechildren(proc, ptable.pLists.ready[i]);
        if(havekids == 1)
          break;
      }
    }

    if(havekids)
    {
      p = ptable.pLists.zombie;
      while(p)
      {
        if(p->parent == proc)
        {
          pid = p->pid;
          kfree(p->kstack);
          p->kstack = 0;
          freevm(p->pgdir);
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          p->killed = 0;
          plistremove(p, &ptable.pLists.zombie);
          p->state = UNUSED;
          plistinsert(p, &ptable.pLists.free);
          release(&ptable.lock);
          return pid;
        }

        else
          p = p->next;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

int
havechildren(struct proc* parent, struct proc* list)
{
  struct proc* p = list;

  while(p)
  {
    if(p->parent == parent)
      return 1;
    else
      p = p->next;
  }

  return 0;
}
#endif

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      #ifdef CS333_P2
      p->cpu_ticks_in = ticks;
      #endif
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle
  int prio;  // For finding the highest priority level with processes in it.

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    // If we have a process we can run
    prio = 0;
    while(prio < MAX_READY_QUEUES + 1)
    {
	  if(ptable.pLists.ready[prio])
	  {
		p = ptable.pLists.ready[prio];
		// Switch to chosen process.  It is the process's job
		// to release ptable.lock and then reacquire it
		// before jumping back to us.
		idle = 0;  // not idle this timeslice
		proc = p;
		switchuvm(p);
		plistremove(p, &(ptable.pLists.ready[prio]));
		p->state = RUNNING;
		plistinsert(p, &ptable.pLists.running);
		#ifdef CS333_P2
		p->cpu_ticks_in = ticks;
		#endif
		swtch(&cpu->scheduler, proc->context);
		switchkvm();

		// Process is done running for now.
		// It should have changed its p->state before coming back.
		proc = 0;
        break;
	  }

      else
        ++prio;
    }

    if(ticks > ptable.PromoteAtTicks)
    {
      dopromotion();
      ptable.PromoteAtTicks += TICKS_TO_PROMOTE;
    }

    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

void
dopromotion(void)
{
  // TODO: P4 - Clean all this up!
  struct proc* p;

  p = ptable.pLists.running;
  while(p)
  {
    if(p->priority > 0)
      p->priority -= 1;

    p = p->next;
  }

  p = ptable.pLists.sleep;
  while(p)
  {
    if(p->priority > 0)
      p->priority -= 1;

    p = p->next;
  }

  int i;
  for(i = 1; i < MAX_READY_QUEUES + 1; ++i)
  {
    p = ptable.pLists.ready[i];
    while(p)
    {
      plistremove(p, &ptable.pLists.ready[i]);
      p->priority -= 1;
      plistinsert(p, &ptable.pLists.ready[p->priority]);

      // In our policy, we will reset the budget
      p->budget = MAX_BUDGET;

      p = ptable.pLists.ready[i];
    }
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  #ifdef CS333_P2
  proc->cpu_ticks_total += (ticks - proc->cpu_ticks_in);
  #endif
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#else
void
sched(void)
{
  int intena;
  int delta_cpu_ticks;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  delta_cpu_ticks = ticks - proc->cpu_ticks_in;
  #ifdef CS333_P2
  proc->cpu_ticks_total += delta_cpu_ticks;
  #endif
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  #ifdef CS333_P3P4
  acquire(&ptable.lock);  //DOC: yieldlock

  plistremove(proc, &ptable.pLists.running);
  proc->state = RUNNABLE;
  updatebudget(proc);
  plistinsert(proc, &(ptable.pLists.ready[proc->priority]));

  sched();
  release(&ptable.lock);
  #else
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
  #endif
}

#ifdef CS333_P3P4
void
updatebudget(struct proc* proc)
{
  proc->budget -= (ticks - proc->cpu_ticks_in);
  if(proc->budget <= 0)
  {
    proc->priority += 1;
    if(proc->priority > MAX_READY_QUEUES)
      proc->priority -= 1;

    proc->budget = MAX_BUDGET;
  }
}
#endif

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  #ifdef CS333_P3P4
  plistremove(proc, &ptable.pLists.running);
  updatebudget(proc);
  proc->state = SLEEPING;
  plistinsert(proc, &ptable.pLists.sleep);
  #else
  proc->state = SLEEPING;
  #endif
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  struct proc* curr = ptable.pLists.sleep;
  struct proc* prev = 0x0;

  while(curr)
  {
    if(curr->chan == chan)
    {
      curr->state = RUNNABLE;

      if(prev == 0x0)
      {
        ptable.pLists.sleep = ptable.pLists.sleep->next;
        plistinsert(curr, &(ptable.pLists.ready[curr->priority]));
        curr = ptable.pLists.sleep;
      }

      else
      {
        prev->next = curr->next;
        plistinsert(curr, &(ptable.pLists.ready[curr->priority]));
        curr = prev->next;
      }
    }

    else
    {
      prev = curr;
      curr = curr->next;
    }
  }
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)
{
  int result = -1;

  acquire(&ptable.lock);

  if(findandkill(pid, ptable.pLists.running))
    result = 0;
  else if(findandkill(pid, ptable.pLists.sleep))
    result = 0;
  else if(findandkill(pid, ptable.pLists.free))
    result = 0;
  else if(findandkill(pid, ptable.pLists.embryo))
    result = 0;
  else if(findandkill(pid, ptable.pLists.zombie))
    result = 0;
  else
  {
    int i;
    for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
    {
      if(findandkill(pid, ptable.pLists.ready[i]))
      {
        result = 0;
        break;
      }
    }
  }

  release(&ptable.lock);

  return result;
}

int
findandkill(int pid, struct proc* list)
{
  struct proc* p;

  p = list;

  while(p)
  {
    if(p->pid == pid)
    {
      p->killed = 1;

      if(list == ptable.pLists.sleep)
      {
        plistremove(p, &ptable.pLists.sleep);
        p->state = RUNNABLE;
        plistinsert(p, &(ptable.pLists.ready[p->priority]));
      }

      return 1;
    }

    else
      p = p->next;
  }

  return 0;
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  #ifdef CS333_P3P4
  cprintf("\n%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	 %s\n", "PID", "Name", "UID", "GID", "PPID", "Priority", "Elapsed", "CPU", "State", "Size", "PCs");
  #elif CS333_P2
  cprintf("\n%s	%s	%s	%s	%s	%s	%s	%s	%s	 %s\n", "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size", "PCs");
  #elif CS333_P1
  cprintf("\n%s	%s	%s	%s		 %s\n", "PID", "State", "Name", "Elapsed", "PCs");
  #endif
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    #ifdef CS333_P1
    fancy_dump(p, state);
	#else
    cprintf("%d %s %s", p->pid, state, p->name);
	#endif
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

#ifdef CS333_P1
void
fancy_dump(struct proc* p, char* state)
{
  #ifdef CS333_P3P4
  // The PPID
  uint ppid;
  // Elapsed running time delta ticks.
  uint edticks;
  // The seconds and milliseconds of elapsed running time.
  uint esec, emil;

  // Like the elapsed running time, we compute our floating
  // value with both a seconds and milliseconds component.
  uint csec, cmil;

  // Calculated the elapsed time in seconds.
  edticks = ticks - p->start_ticks;
  esec = edticks / 1000;
  emil = edticks % 1000;

  // Calculate total CPU time in seconds
  csec = p->cpu_ticks_total / 1000;
  cmil = p->cpu_ticks_total % 1000;

  ppid = p->parent ? p->parent->pid : 1;

  cprintf("%d	%s	%d	%d	%d	%d		%d.%d	%d.%d	%s	%d	", p->pid, p->name, p->uid, p->gid, ppid, p->priority, esec, emil, csec, cmil, state, p->sz);
  #elif CS333_P2
  // The PPID
  uint ppid;
  // Elapsed running time delta ticks.
  uint edticks;
  // The seconds and milliseconds of elapsed running time.
  uint esec, emil;

  // Like the elapsed running time, we compute our floating
  // value with both a seconds and milliseconds component.
  uint csec, cmil;

  // Calculated the elapsed time in seconds.
  edticks = ticks - p->start_ticks;
  esec = edticks / 1000;
  emil = edticks % 1000;

  // Calculate total CPU time in seconds
  csec = p->cpu_ticks_total / 1000;
  cmil = p->cpu_ticks_total % 1000;

  ppid = p->parent ? p->parent->pid : 1;

  cprintf("%d	%s	%d	%d	%d	%d.%d	%d.%d	%s	%d	", p->pid, p->name, p->uid, p->gid, ppid, esec, emil, csec, cmil, state, p->sz);
  #else
  // This is where we store the difference in time from
  // a process's start ticks and the current ticks.
  uint delta_tick;
  // printf cannot print floats, so we calculate the seconds
  // and milliseconds as different parts.
  uint sec, millisec;

  delta_tick = ticks - p->start_ticks;
  sec = delta_tick / 1000;
  millisec = delta_tick % 1000;
  cprintf("%d	%s	%s	%d.%d		", p->pid, state, p->name, sec, millisec);
  #endif
}
#endif

#ifdef CS333_P2
int
get_active_procs(uint max, struct uproc* table)
{
	// Stores the index of the current process in the
	// ptable
	uint curr_proc;
	// Stores the index of the next available spot in table
	int curr_table_index;
	// Stores the number of processes we actually added
	int num_read_processes;
	// Use this to conveniently access the current proc.
	struct proc* proc;

	// Special case: number of processes we want is less than
	// the number of procceses in the table
	if(max > NPROC)
		return -1;

	// We do not want to read the array of processes if
	// other people are modifying it.
	acquire(&ptable.lock);

	curr_proc = 0;
	curr_table_index = 0;
	num_read_processes = 0;

	for(; curr_proc < max; ++curr_proc)
	{
		proc = &ptable.proc[curr_proc];

		if(proc->state == RUNNABLE || proc->state == RUNNING || proc->state == SLEEPING)
		{
			safestrcpy(table[curr_table_index].name, proc->name, STRMAX);
			table[curr_table_index].pid = proc->pid;
			table[curr_table_index].uid = proc->uid;
			table[curr_table_index].gid = proc->gid;
			table[curr_table_index].ppid = proc->parent ? proc->parent->pid : proc->pid;
			table[curr_table_index].elapsed_ticks = ticks - proc->start_ticks;
			table[curr_table_index].cpu_total_ticks = proc->cpu_ticks_total;
			table[curr_table_index].size = proc->sz;
			#ifdef CS333_P3P4
			table[curr_table_index].priority = proc->priority;
			#endif

			// A very crumby way, but whatever.
			if(proc->state == RUNNABLE)
				safestrcpy(table[curr_table_index].state, "RUNNABLE", STRMAX);
			else if(proc->state == RUNNING)
				safestrcpy(table[curr_table_index].state, "RUNNING ", STRMAX);
			else if(proc->state == SLEEPING)
				safestrcpy(table[curr_table_index].state, "SLEEPING", STRMAX);

			++curr_table_index;
			++ num_read_processes;
		}
	}

	release(&ptable.lock);

	return num_read_processes;
}
#endif

#ifdef CS333_P3P4
int
dosetpriority(int pid, int priority)
{
  struct proc* p;

  acquire(&ptable.lock);

  if(priority < 0 || priority > MAX_READY_QUEUES)
  {
    release(&ptable.lock);
    return -1;
  }

  p = getproc(pid, ptable.pLists.running);
  if(setprocpriority(p, priority))
  {
    release(&ptable.lock);
    return 1;
  }

  p = getproc(pid, ptable.pLists.sleep);
  if(setprocpriority(p, priority))
  {
    release(&ptable.lock);
    return 1;
  }

  int i;
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
  {
    p = getproc(pid, ptable.pLists.ready[i]);
    if(p)
    {
      // Don't want to change it if it's in the correct
      // list already.
      if(p->priority == priority)
      {
        release(&ptable.lock);
        return 1;
      }

      plistremove(p, &ptable.pLists.ready[p->priority]);
      p->priority = priority;
      p->budget = MAX_BUDGET;
      plistinsert(p, &ptable.pLists.ready[p->priority]);
      release(&ptable.lock);
      return 1;
    }
  }

  release(&ptable.lock);
  return 0;
}

int 
setprocpriority(struct proc* proc, int priority)
{
  if(proc)
  {
    proc->budget = MAX_BUDGET;
    proc->priority = priority;
    return 1;
  }

  return 0;
}

struct proc*
getproc(int pid, struct proc* list)
{
  struct proc* p = list;

  while(p)
  {
    if(p->pid == pid)
      break;
    else
      p = p->next;
  }

  return p;
}

void
printready(void)
{
  struct proc* p;
  int i;

  cprintf("Ready Lists:\n");

  acquire(&ptable.lock);
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
  {
    cprintf("%d: ", i);
	p = ptable.pLists.ready[i];

	while(p)
	{
	  cprintf("(%d, %d)", p->pid, p->budget);

	  if(p->next)
		cprintf("->");

	  p = p->next;
	}

	cprintf("\n");
  }

  release(&ptable.lock);
  cprintf("------------------\n");
}

void
printnumfree(void)
{
  int num_free = 0;
  struct proc* p;

  acquire(&ptable.lock);

  p = ptable.pLists.free;
  while(p)
  {
    ++num_free;
    p = p->next;
  }

  release(&ptable.lock);

  cprintf("Free list size: %d processes\n", num_free);
}

void
printsleep(void)
{
  struct proc* p;

  acquire(&ptable.lock);

  p = ptable.pLists.sleep;
  while(p)
  {
    cprintf("%d", p->pid);

    if(p->next)
      cprintf("->");

    p = p->next;
  }

  cprintf("\n");

  release(&ptable.lock);
}

void
printzombie(void)
{
  struct proc* p;
  uint parent;

  acquire(&ptable.lock);

  p = ptable.pLists.zombie;

  while(p)
  {
    parent = p->parent ? p->parent->pid : p->pid;

    cprintf("(%d,%d)", p->pid, parent);

    if(p->next)
      cprintf("->");

    p = p->next;
  }

  cprintf("\n");

  release(&ptable.lock);
}
#endif
