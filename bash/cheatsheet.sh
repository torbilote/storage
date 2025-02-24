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

Backslash character are used to remove the special meaning of a single character. \. (except of newline).

Single quotes are used to preserve the literal value of all characters enclosed within the quotes. ''.
A single quote cannot occur between single quotes, even preceded by a backslash.

Double quotes are used to  preserve the literal value of all characters except for dollar sign $, backticks `` and backshlash \.
Dolar and backticks retain their special meanining whereas backslash retains its meaning ONLY when followed by dollar, backtick, double quote, backslash or newline.
Within double quotes, the backslashes are removed 
In zsh use echo with -E flag to have the same effect as echo in bash (-E flag preserves backslashes when its followed by something other than dollar etc. )

tx=hello
echo -E $tx => hello
echo -E \$tx => $tx

echo -E 'hey $tx \t \$pzdr tab' => hey $tx \t \$pzdr tab
echo -E "hey $tx \t \$pzdr tab" => hey hello \t $pzdr tab
echo    "hey $tx \t \$pzdr tab" => hey hello        $pzdr tab
echo    'hey $tx \t \$pzdr tab' => hey $tx          \$pzdr tab

Backtick is used when you want to embed the command within your command. Everything between backticks is evaluated(executed) before the main command and the output is consumed by main command.
echo -E "hey `date`" => hey Wed Feb 19 17:41:32 CET 2025

Brace expansion can generate arbitraty strings.
<optional_prefix>{words,separated,by,comma}<optional suffix>
echo -E hello{" you"," me"}!

$ character introduces parameter expansion, command substitution or arithmetic expansion.
Parameter expansion:
tx=hello
echo "${tx}world" - is required so the latter part of the string is not interpreted as var name.

Command subsitution:
echo "today is $(date)" - date command is executed and its output replaces itself. Same as with backticks.

Arithmetic expansion:
echo $((5**1-2)) - allows the evaluation of arithmetic expression
echo $[5**1-2] - another format

File name expansion:
Special characters used for it: * ? [ ]
If one of these chars is used in the word, then it is regarded as a pattern.
???

Alias allows a string to be substituted for a word when it is used as the first word of a simple command.
alias without options display a list of aliases known in current shell.
alias lll="ls -l"
Aliases are not inherited by child processes.

Display all bash options:
set -o

Regular expression is a pattern that describes a set of strings.
Most characters including letters and digits are regular expressions that match themselves.
Any metacharacter with special meaning may be quoted by preceding it with a backslash.
Two regexps may be concatenated resulting any string formed by two substrings that respectively match subexpressions.
Two regexps may be joined by infix "|" resulting any string matching either subexpression.
In basic regexp the metacharacters "?", "+", "{" , "|"m "(" lose their special meaning. instead use backslashed versions \? \+ ...

re operators:
.	Matches any single character.
?	The preceding item is optional and will be matched, at most, once.
*	The preceding item will be matched zero or more times.
+	The preceding item will be matched one or more times.
{N}	The preceding item is matched exactly N times.
{N,}	The preceding item is matched N or more times.
{N,M}	The preceding item is matched at least N times, but not more than M times.
-	represents the range if it's not first or last in a list or the ending point of a range in a list.
^	Matches the empty string at the beginning of a line; also represents the characters not in the range of a list.
$	Matches the empty string at the end of a line.
\b	Matches the empty string at the edge of a word.
\B	Matches the empty string provided it's not at the edge of a word.
\<	Match the empty string at the beginning of word.
\>	Match the empty string at the end of word.

grep searches the input files for lines containing a match to a given pattern list.
newline is a separator for the list of patterns.
grep -n adds line number

A bracket expression is a list of characters enclosed by [ ]. It matches any single character in that list. If the first character starts with ^
then it matches any character not in the list.

Within bracket expression you can use range expression, two characters sepearated by a hyphen. Its local sequence of characters.
[a-d] is equal [abcd]

Character classes like "alnum", "alpha" "ascii" "digit" "upper" can be specified using syntax [:CLASS:]
ls [[:digit]]*

sed - Stream EDitor - used to perform basic transformations on text read from a file or a pipe.
Result sent to standard output by default. Redirect if you want to save it to file.
sed can perform text pattern substitutions and deletions.

sed editing commands:
a\	Append text below current line.
c\	Change text in the current line with new text.
d	Delete text.
i\	Insert text above current line.
p	Print text.
r	Read a file.
s	Search and replace text.
w	Write to a file.

sed options:
-e SCRIPT	Add the commands in SCRIPT to the set of commands to be run while processing the input.
-f	Add the commands contained in the file SCRIPT-FILE to the set of commands to be run while processing the input.
-n	Silent mode.
-V	Print version information and exit.

sed -n '/erors/p' example - print matched lines
sed '/erors/d' example - print all but matched lines
sed 's/erors/errors/g' example - search and replace all occurances in each line
sed 's/^/> /' example - insert char at the beginning of each line

