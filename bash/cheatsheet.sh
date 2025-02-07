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

