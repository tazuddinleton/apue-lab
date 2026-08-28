# APUE NetBSD 9.0 Lab

This lab supports the **Advanced Programming in the UNIX Environment** video
course:

<https://www.youtube.com/watch?v=BsB9Cg6yJc4&list=PL0qfF8MrJ-jxMfirAdxDs9zIiBg2Wug0z&index=1>

The first target is NetBSD 9.0 with the base GCC 7.4.0 toolchain. The
environment is intentionally small and Unix-like so the exercises focus on
processes, files, permissions, system calls, signals, and the C runtime rather
than application frameworks.

## Requirements on the host

- Vagrant
- A working provider, preferably `libvirt` on Linux or VirtualBox
- Internet access for the first box download
- At least 2 GB RAM and 10 GB free disk space

The Vagrantfile configures both `libvirt` and VirtualBox. Select a provider
explicitly if Vagrant does not choose the one you use:

```sh
vagrant up --provider=libvirt
# or
vagrant up --provider=virtualbox
```

The `generic/netbsd9` box is used because Vagrant boxes are provider-specific.
The provisioning script verifies that the guest reports NetBSD 9.x and GCC
7.4.x; it fails loudly rather than silently giving you a different toolchain.

## Start and stop

```sh
cd ~/Learn/apue-netbsd-lab
vagrant up --provider=libvirt
vagrant ssh
cd ~/apue
vagrant suspend
vagrant halt
vagrant destroy
```

Use `vagrant destroy` only when you are comfortable recreating the VM. Your
source files should live in the repository or a Vagrant-synced directory, not
only inside the guest.

## First checks inside the guest

```sh
uname -a
uname -r
gcc --version
make -v
man 2 open
man 2 fork
man 3 printf
```

NetBSD's base system includes the compiler and core Unix tools. Do not install
Linux packages or use `apt`; this lab is deliberately teaching the NetBSD/POSIX
environment.

## Suggested exercise sequence

### Week 1: Orientation

Record the output and explain each result:

```sh
id
pwd
env
echo "$PATH"
ls -la /
ls -la /bin /usr/bin
which gcc
whence gcc
```

Questions:

- Which commands are shell built-ins and which are external programs?
- How does `PATH` affect command lookup?
- What is the difference between `/bin`, `/sbin`, `/usr/bin`, and `/usr/sbin`
  on this system?
- Which user owns the shell process?

### Week 2: Compile and inspect a C program

Create your own `src/hello.c`. Compile it with warnings enabled:

```sh
gcc -std=c11 -Wall -Wextra -pedantic -g src/hello.c -o bin/hello
./bin/hello
file bin/hello
ldd bin/hello
nm bin/hello | head
```

Do not copy a finished solution from the tutorial. Change the program, predict
the result, then test your prediction.

### Week 3: System-call observation

Use the manual pages before writing code:

```sh
man 2 write
man 2 read
man 2 open
man 2 close
man 2 stat
man 2 getpid
man 3 strerror
```

For each call, write down its inputs, return value, `errno` behavior, and one
failure case. Then implement a tiny experiment that exercises one call.

### Week 4: Processes and signals

Study:

```sh
man 2 fork
man 2 execve
man 2 wait
man 2 kill
man 7 signal
ps -aux
```

Build experiments that create a child, observe its PID and PPID, and handle a
termination signal. Explain what happens when the parent exits first.

## Working rules

- Keep one experiment per source file with a short note describing the
  hypothesis and observation.
- Check return values from every system call.
- Print errors with both the operation and the system error.
- Compile with `-Wall -Wextra -pedantic -g` while learning.
- Use `man` first and search the source tree only after forming a hypothesis.
- Never experiment with `kill`, `chmod`, `chown`, `mount`, or raw disk devices
  outside this disposable VM.

## Lab notebook

For every tutorial episode, record:

```text
Episode:
Concept:
Hypothesis:
Command or program:
Observed result:
Failure case:
What I can now explain:
```

## Troubleshooting

Check the provider and box metadata:

```sh
vagrant status
vagrant box list
vagrant global-status
```

If provisioning fails, read the first failed check. The script intentionally
stops on an unexpected NetBSD release or compiler version.

If `generic/netbsd9` is unavailable for your provider, do not silently switch
to a Linux box. Find a NetBSD 9 provider-compatible box, update the
`config.vm.box` value, and keep the release/compiler checks intact.
