# Strace

- Logs System Calls
- Makes two type of calls
    - System calls - Enter a kernel
    - User calls

For example the ls command works like this:

```
Command-line utility -> Invokes functions from system libraries (glibc) -> Invokes system calls
```

To see which functions are called just use ltrace

```
ltrace ls /directory
```