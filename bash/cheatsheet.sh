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
grep -v returns all that don't match the pattern.

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

awk - another stream editor (and programming language) basic function is to search files for lines or other text units containing one or more patterns.
When a line matches one of the patterns, special actions are performed on that line.

ls -l | grep a | awk '{ print "hello "$9"" }'

formatting characters for awk
\a	Bell character
\n	Newline character
\t	Tab

In order to precede and follow output with comments, use the BEGIN and END statements:
ls -l | awk 'BEGIN {print "Files found:\n"} /\<[a-z].*$/ { print $0} END { print "Thank you" }'

df -h - show informatino about the file system.

$FS - built-in variable stands for field separator (different than IFS variable). It is a single char or regular exp - controls the way awk splits up an input into fields.
awk 'BEGIN { FS=":" } { print $1 "\t" $5 }' /etc/passwd

$OFS output field separator
$ORS output record separator
$NR - number of processed records

use printf instead of print to have even more control

conditional statements

if TEST-COMMAND; then CONSEQUENT-COMMAND; elif MORE-TEST-COMMAND; then MORE-CONSEQUENT-COMMAND; else ALTERNATIVE-COMMAND; fi

returned status 0 - when succeeded, some other status otherwise

The table below contains an overview of the so-called "primaries" that make up the TEST-COMMAND command.
Primaries are put between square brackets to indicate the conditional expresion
Primary	Meaning
[ -a FILE ]	True if FILE exists.
[ -d FILE ]	True if FILE exists and is a directory.
[ -e FILE ]	True if FILE exists.
[ -f FILE ]	True if FILE exists and is a regular file.
[ -r FILE ]	True if FILE exists and is readable.
[ -s FILE ]	True if FILE exists and has a size greater than zero.
[ -w FILE ]	True if FILE exists and is writable.
[ -x FILE ]	True if FILE exists and is executable.
[ -O FILE ]	True if FILE exists and is owned by the effective user ID.
[ -G FILE ]	True if FILE exists and is owned by the effective group ID.
[ -z STRING ]	True if the length of "STRING" is zero.
[ -n STRING ] or [ STRING ]	True if the length of "STRING" is non-zero.
[ STRING1 == STRING2 ]	True if the strings are equal. "=" may be used instead of "==" for strict POSIX compliance.
[ STRING1 != STRING2 ]	True if the strings are not equal.
[ STRING1 < STRING2 ]	True if "STRING1" sorts before "STRING2" lexicographically in the current locale.
[ STRING1 > STRING2 ]	True if "STRING1" sorts after "STRING2" lexicographically in the current locale.
[ ARG1 OP ARG2 ]	"OP" is one of -eq, -ne, -lt, -le, -gt or -ge. These arithmetic binary operators return true if "ARG1" 
is equal to, not equal to, less than, less than or equal to, greater than, or greater than or equal to "ARG2", respectively.
"ARG1" and "ARG2" are integers.

Combining expressions
Operation	Effect
[ ! EXPR ]	True if EXPR is false.
[ ( EXPR ) ]	Returns the value of EXPR. This may be used to override the normal precedence of operators.
[ EXPR1 -a EXPR2 ]	True if both EXPR1 and EXPR2 are true.
[ EXPR1 -o EXPR2 ]	True if either EXPR1 or EXPR2 is true.

if [ -f /var/log/messages ]
  then
    echo "/var/log/messages exists."
fi

if [ $? -eq 0 ]
    then echo 'That was a good job!'
fi

Shorten version
[ $? -eq 0 ] && (echo 'That was a good job!')

&& expression indicates command to execute if the preceding command proves true
|| expression indicates command to execute if the preceding command proves false

test built-in cmd as alternative
test $? -eq 0 && (echo 'That was a good job!')


if [ $? -eq 0 ] ; then echo 2 ; fi
vs
if [[ $? -eq 0 ]] ; then echo 2 ; fi
Contrary to [, [[ prevents word splitting of variable values. So, if VAR="var with spaces", 
you do not need to double quote $VAR in a test - eventhough using quotes remains a good habit.
Also, [[ prevents pathname expansion, so literal strings with wildcards do not try to expand to filenames.
Using [[, == and != interpret strings to the right as shell glob patterns to be matched against the value to the left,
for instance: [[ "value" == val* ]].

sort -n sorts ascending
tail -1 takes last record
head -1 takes first record
cut prints selected part of line

Boolean operators AND (&&) and OR (||)

exit - terminates the execution of entire script. Takes status code as optional argument (passed back as and stored in $? variable)
0 status code means script runs successfully.


case EXPRESSION in
case1) COMMANDS;;
case2) COMMANDS;;
*) COMMANDS;;
esac

example: case $dd in "siem") echo 1;; "siema") echo 2;; *) echo 3;; esac

echo -e - interprets backslash-escaped characters
echo -n - no new line at the end

Other sequence used by echo command:
Sequence	Meaning
\a	Alert (bell).
\b	Backspace.
\c	Suppress trailing newline.
\e	Escape.
\f	Form feed.
\n	Newline.
\r	Carriage return.
\t	Horizontal tab.
\v	Vertical tab.
\\	Backslash.

read built-in is counterpart of echo. It reads a line from the standard input or from the file supplied.
read [options] name1 name2 ... nameN
first word of line is assigned to first name, second to second name and so on..
leftover words assigned to the last name.
If fewer words than read names, the reamining names are empty.
If no names supplied, line read is assigned to variable REPLY.


Option	Meaning
-a ANAME	The words are assigned to sequential indexes of the array variable ANAME, starting at 0. All elements are removed from ANAME before the assignment. Other NAME arguments are ignored.
-d DELIM	The first character of DELIM is used to terminate the input line, rather than newline.
-e	readline is used to obtain the line.
-n NCHARS	read returns after reading NCHARS characters rather than waiting for a complete line of input.
-p PROMPT	Display PROMPT, without a trailing newline, before attempting to read any input. The prompt is displayed only if input is coming from a terminal.
-r	If this option is given, backslash does not act as an escape character. The backslash is considered to be part of the line. In particular, a backslash-newline pair may not be used as a line continuation.
-s	Silent mode. If input is coming from a terminal, characters are not echoed.
-t TIMEOUT	Cause read to time out and return failure if a complete line of input is not read within TIMEOUT seconds. This option has no effect if read is not reading input from the terminal or from a pipe.
-u FD	Read input from file descriptor FD.

Input and output can be redirected before it is executed using redirection operators.
Redirection also can be used to open/close files for current shell.

The file descriptors are numeric values that tracks all files for given process.
The best known file descriptors are stdin, stdout and stderr with numbers 0, 1 and 2 respectively. These numbers are reserved.

To redirect stdout to file.txt:
echo "test" > file.txt
or
echo "test" 1> file.txt (since stdout file descriptor is 1)

To redirect stderr to file.txt:
echo "test" 2> file.txt

>& is the syntax to redirect a stream to another file descriptor so:
to redirect stdout to stderr:
echo "test" 1>&2
or
echo "test" >&2

ti redurect stderr to stdout:
echo "test" 2>&1

> means overwrite target if exists
>> means append to target if exists
both creates file if does not exist

Order of redirections matters!

ls -ld /tmp /tnt >file 2>&1  - first redirects stdout to file. then redirects stderr to the current stdout (which is file). Both streams points to file.
ls -ld /tmp /tnt 2>&1 >file - first redirects stderr to current stdout (terminal). then redirects stdout to file - it has no effect on previous stderr redirection as it was locked-in to whatever stdout was defined as. 
Effect: stderr points to terminal, stdout points to file.

