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
The variables, functions and aliases created in subshell are only known to the session of the subshell.
When subshell terminates and a parent regains control, everything is cleaned up and all changes made to the state of the shell in subshell are forgotten.


Shell script always starts with the same two characters "#!". After that, the shell that will execute the script commands is defined.
Standard location of installed bash is /bin/bash.

When you run
./script_name.sh - uses shell defined in first line of the script
bash script_name.sh - uses shell from the command line (bash in this case) - recommended only for testing
the new bash shell will start as a subshell of current shell and execute the script.

If you want to execture the script in the current shell, you run built-in command:
source script_name.sh (bash notation, synonym of .)
. script_name.sh (sh notation)
In this case script does not need 'execute' permission in this case.
All changes made in your environment by the script will be visible after script execution.

To run the script in a subshell in debug mode run:
bash -x script_name.sh
-x flag displays every single line script executes so it helps to trace the script logic. Comments are not visible though.

You can use built-in set command to run only part of the script in debug mode.
You can enclose the line(s) like following. In this case, debug mode is activated only to run 'w' command.
...
set -x
w
set -x
...

Set debugging options:
short notation | long notation | result
set -v | set -o verbose | print shell input lines as they are read
set -x | set -o xtrace | print command traces before executing command

Important! A dash is used to activate a shell option, a plus to deactivate it.

Variables are not inherited by child processes (subshells) unless they are exported by the parent shell.
Shell variables are uppercase by convention.
There are 2 types of variables: global and local.

Global (or environment) variables are available in all shells.
printenv to display env variables.

Local variables are only available in the current shell.
set without options will display list of all variables and functions (including env vars).
Variables are case sensitive.
VARNAME="value" (spaces around equal sign not allowed)
Good habit to quote content strings when assigning to variables.
To pass variables to subshells you need to export it using built-in command.
export VARNAME="value"
Subshell can change variables inherited from parent but changes made by child don't affect the parent.

The positional parameters are the words following the name of a shell script.
They are put into the variables $1, $2, $3 and so on. 

There are several parameters treated specially. Can be only referenced.
Character	Definition
$*	Expands to the positional parameters, starting from one. When the expansion occurs within double quotes, it expands to a single word with the value of each parameter separated by the first character of the IFS special variable.
$@	Expands to the positional parameters, starting from one. When the expansion occurs within double quotes, each parameter expands to a separate word.
$#	Expands to the number of positional parameters in decimal.
$?	Expands to the exit status of the most recently executed foreground pipeline.
$-	A hyphen expands to the current option flags as specified upon invocation, by the set built-in command, or those set by the shell itself (such as the -i).
$$	Expands to the process ID of the shell.
$!	Expands to the process ID of the most recently executed background (asynchronous) command.
$0	Expands to the name of the shell or shell script.
$_	The underscore variable is set at shell startup and contains the absolute file name of the shell or script being executed as passed in the argument list. Subsequently, it expands to the last argument to the previous command, after expansion. It is also set to the full pathname of each command executed and placed in the environment exported to that command. When checking mail, this parameter holds the name of the mail file.

!important	
The implementation of "$*" has always been a problem and realistically should have been replaced with the behavior of "$@". In almost every case where coders use "$*", they mean "$@". "$*" Can cause bugs and even security holes in your software.






