---
layout: default
---

## First: Homework Questions


## Adding a Syscall to xv6

We need a halt instruction so we can stop the system for automated tests, so
we're going to use that as our example.

This has already been added to our master branch, first checkout the
raw mit code.

```
$ git checkout mit-default
$ git checkout -b add-halt-syscall
```

### Step 1: Add a syscall number

 - open syscall.h
 - Syscall numbers 1-21 are taken, so we'll make our new syscall # 22

```
#define SYS_halt   22
```

### Step 2: Add syscall to the list in syscall.c

```
extern int sys_halt(void);
...
[SYS_halt]    sys_halt,
```

### Step 3: Implement the syscall

Add the implementation to sysproc.c:

```
int
sys_halt()
{
  outw(0x604, 0x2000);
  return 0;
}
```

Finding the shutdown command was interesting. Qemu has apparently changed the
shutdown interface several times, and most of the old examples are wrong.

Eventually I looked at Redox OS, since I knew they had this problem and would
care enough to solve it.

### Step 4: Add a userspace wrapper.

Add the declaration to user.h:

```
int halt(void);
```

### Step 5: Add a test program.

Create halt.c:

```
#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int _ac, char *_av[])
{
  halt();
  return 0;
}
```

Add it to the Makefile

```
UPROGS=\
   ...
   _halt\
   ...
```

## References

 - https://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
 - https://medium.com/@silvamatteus/adding-new-system-calls-to-xv6-217b7daefbe1
 - https://gitlab.redox-os.org/redox-os/kernel/blob/master/src/arch/x86_64/stop.rs
