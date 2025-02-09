Shell is a program that interprets user command entered by the user directly or read from file.
Shell scripts are interpreted, not compiled.
Shell passes command to the kernel.
Shell also provides user environment which can be configured individually.
Shell types:
    - sh (Bourne Shell) - the original shell used on UNIX systems (Unix is one of the operating system types.)
    - bash (Bourne Again Shell) - standard shell for Linux users, called a superset of sh. Compatible with sh. What works in sh, works in bash. Not in reverse.


# The foll. file gives an overview of known shells on Linux system
cat /etc/shells

# Your default shell can be found in foll. file next to your username
cat /etc/passwd 

To switch to other shell, enter the name of the shell. System finds the directory using PATH env variable, if found, it executes it (since shell is a program)

Interactive means you can enter commands and reads the output via user's terminal.
Scripts are non-interactive.

# To check if shell is interactive (and many other parameters) look if there is 'i' in the output.
echo $-

Bash supports 3 types of built-in commands:
- sh built-in commands:
    :, ., break, cd, continue, eval, exec, exit, export, getopts, hash, pwd, readonly, return, set, shift, test, [, times, trap, umask and unset.
- bash built-in commands:
    alias, bind, builtin, command, declare, echo, enable, help, let, local, logout, printf, read, shopt, type, typeset, ulimit and unalias.
- special POSIX built-in commands:
    ...

When the program being executed is a shell script, bash will create a new bash process using a fork.
This subshell reads the lines, interprets and executes as if they would come directly from the keyboard line by line.
While subshell processes each line, the parent shell waits for its child to finish.
When subshell terminates, the parent awakes and displays a new prompt.

Shell script always starts with the same two characters "#!". After that, the shell that will execute the script commands is defined.
Standard location of installed bash is /bin/bash.

