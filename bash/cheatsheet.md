# Bash Scripting Cheatsheet

## Introduction

Bash (Bourne Again Shell) is a command-line interpreter and scripting language widely used in UNIX and Linux environments. This document provides a structured reference for Bash programming, covering fundamental concepts, commands, and scripting techniques.

---

## 1. Shell Basics

### What is a Shell?
- A shell is a program that interprets user commands entered interactively or from a script.
- Shell scripts are **interpreted**, not compiled.
- The shell passes commands to the **kernel** for execution.
- The shell provides a configurable user environment.

### Common Shells
- **sh** (Bourne Shell) – Original UNIX shell.
- **bash** (Bourne Again Shell) – Standard shell in Linux, compatible superset of `sh`. What works in sh, works in bash. Not in reverse.

### Check Available Shells
```bash
cat /etc/shells
```

### Check Default Shell
```bash
cat /etc/passwd | grep "$USER"
```
or
```bash
echo $SHELL
```

### Switching Shells
Type the shell name (e.g., `bash`, `sh`, `zsh`). The system finds and executes it using the `$PATH` variable.

### Interactive vs. Non-Interactive Shells
- **Interactive**: Accepts user input and provides the output via terminal.
- **Non-Interactive**: Executes commands from a script.

Check if a shell is interactive by looking for 'i' letter in the output:
```bash
echo $-
```

---

## 2. Bash Built-in Commands

### Types of Commands
1. **sh Built-in Commands**: `:`, `.`, `break`, `cd`, `continue`, `eval`, `exec`, `exit`, `export`, `getopts`, `hash`, `pwd`, `readonly`, `return`, `set`, `shift`, `test`, `[`, `times`, `trap`, `umask` and `unset`.
2. **bash Built-in Commands**: `alias`, `bind`, `builtin`, `command`, `declare`, `echo`, `enable`, `help`, `let`, `local`, `logout`, `printf`, `read`, `shopt`, `type`, `typeset`, `ulimit` and `unalias`.
3. **POSIX Special Built-in Commands**: Used in strict POSIX mode.

---

## 3. Running Scripts

### Script Execution
When the program being executed is a shell script, bash will create a new bash process using a fork.
This subshell reads the lines, interprets and executes as if they would come directly from the keyboard line by line.
While subshell processes each line, the parent shell waits for its child to finish.
When subshell terminates, the parent awakes and displays a new prompt.
The variables, functions and aliases created in subshell are only known to the session of the subshell.
When subshell terminates and a parent regains control, everything is cleaned up and all changes made to the state of the shell in subshell are forgotten.

- Bash scripts always   start with `#!` (shebang) followed by the interpreter path:
  ```bash
  #!/bin/bash
  ```
- Run a script in a subshell of current shell:
  ```bash
  ./script.sh  # Uses the shell defined in the shebang
  bash script.sh  # Uses the shell from the command line
  ```
- Run in the current shell. All changes made in current shell envinroment will be visible after script execution:
  ```bash
  source script.sh  # Bash notation
  . script.sh       # sh notation
  ```

### Debugging Scripts
- Execute with debugging. It displays every line script executes:
  ```bash
  bash -x script.sh
  ```
- Debug specific sections:
  ```bash
  set -x # set -o verbose. Dash used to activate an option.
  echo "Debugging..."
  set +x # set +o verbose. Plus used to deactive an option.
  ```
- Display all bash options:
  ```bash
  set -o
  ```

---

## 4. Variables

### Types of Variables
- **Global (Environment) Variables**: Available in all shells.
- **Local Variables**: Available only in the current shell.

### Creating Variables
```bash
VARNAME="value"  # No spaces around = . Such local variable is not inherited by child processes (subshells).
export VARNAME   # Make it global therefore available in subshells too.
export VARNAME="value" # Assignment and export at once.
```
Variables are case sensitive.
Good habit to quote the content when assigning to variables.
Subshell can change variables inherited from parent but changes made by child don't affect the parent.

### Display Variables
```bash
printenv  # Show environment variables
set       # Show all variables
```

### Referencing Variables
```bash
echo $SHELL
echo ${SHELL}
```
### Special Variables
The positional parameters are the words following the name of a shell script. They are put into the variables $1, $2, $3 and so on respectively. Also there are several special parameters that can only be referenced. 

| Variable | Description |
|----------|-------------|
| `$0` | Script name |
| `$1`, `$2`, ... | Positional parameters |
| `$*` | All positional parameters as a single string |
| `$@` | All positional parameters as separate words. Recommended over `$*` |
| `$#` | Number of positional parameters |
| `$$` | PID of the shell |
| `$!` | PID of the last background command |
| `$?` | Exit status of the last executed command |
| `$-` | Current option flags |

---

## 5. String Operations

### Quoting Mechanisms
- **Single Quotes `'`**: Preserves literal value.
- **Double Quotes `"`**: Preserves all characters except `$`, `"`, and ``\``.
- **Backticks `` `command` `` /**: Command substitution.
- **Dollar sign `$(command)`** : Command substitution.
- **Dollar sign `$((command))` or `$[command]`** : Evaluates mathematical operation.
- **Backslash `\`**: Removes the special meaning of a single character except new line character `\n`. In `echo` built-in function it defines special formatting characters.
```bash
echo "Hello from $SHELL. Wer are in $(pwd) or \$(pwd) or `pwd`. 2+2 equals $((2+2)). \nNew line and the \t tab. \"Cheers.\" "
```

In `zsh` use `echo` with -E flag to have the same effect as `echo` in `bash` (-E flag preserves backslashes when its followed by something other than dollar etc. )
---

### Brace expansion
???

## 6. File Name Expansion 
If one of these chars is used in the word, then it is regarded as a pattern.
### Wildcards in File Name Expansion
| Character | Description |
|-----------|-------------|
| `*`       | Matches any string of characters |
| `?`       | Matches any single character |
| `[ ]`     | Matches any character enclosed within |

```bash
echo *.txt  # Lists all .txt files in the directory
```
---
## 7. Aliases
Alias allows a string to be substituted for a string when it is used as the first word of a simple command. Aliases are not inherited by child processes.
### Creating an Alias
```bash
alias lll="ls -l"  # Creates an alias for 'ls -l'
```

### Display All Aliases
```bash
alias  # Shows all defined aliases
```

## 8. Regular Expressions
A **regular expression** (regex) is a pattern that describes a set of strings used to match text. Most characters including letters and digits are regular expressions that match themselves.
Any metacharacter with special meaning may be quoted by preceding it with a backslash.
Two regexps may be concatenated resulting any string formed by two substrings that respectively match subexpressions.
Two regexps may be joined by infix "|" resulting any string matching either subexpression.

### Basic Regex Operators
| Operator | Description |
|----------|-------------|
| `.`      | Matches any single character |
| `?`      | Matches preceding item 0 or 1 times |
| `*`      | Matches preceding item 0 or more times |
| `+`      | Matches preceding item 1 or more times |
| `{N}`    | Matches preceding item exactly N times |
| `{N,}`   | Matches preceding item exactly N times or more |
| `{N,M}`  | Matches preceding item at least N times but not more than M times |
| `^`      | Matches beginning of line |
| `$`      | Matches end of line |

### Bracket Operator
| Operator | Description |
|----------|-------------|
| `[]`      | Matches given list of item or range of items |

A bracket expression is a list of characters enclosed by [ ]. It matches any single character in that list. If the first character starts with ^
then it matches any character not in the list.

Within bracket expression you can use range expression, two characters sepearated by a hyphen. Its local sequence of characters.
[a-d] is equal [abcd]

Character classes like "alnum", "alpha" "ascii" "digit" "upper" can be specified using syntax [:CLASS:]
ls [[:digit]]*

## 9. grep built-in command
`grep` searches the input files for lines containing a match to a given pattern list. Newline character is a separator for the list of patterns.

Example:
```bash
echo "hello" | grep "^h"  # Matches lines starting with 'h'
```

### Useful `grep` Options
| Option | Description |
|--------|-------------|
| `-n`   | Shows line numbers |
| `-v`   | Returns lines that do **not** match |
| `-i`   | Case-insensitive search |

## 10. Sed
`sed` or Stream EDitor - performs basic transformations on text read from a file or a pipe. Can perform text pattern substitutions and deletions.

```bash
sed [OPTIONS] 'command' [inputfile]
```

### Options
| Option | Description |
|--------|-------------|
| `-i`   | Edit the file in place without printing to the console (overwrite the file) |
| `-n`   | Suppress automatic printing of lines. |
| `-e`   | Allows multiple commands to be executed. |
| `-f`   | Reads sed commands from a file instead of the command line. |

### Commands
| Command | Description |
|---------|-------------|
| `a\`   | Append text after the current line |
| `c\`   | Replace text in the current line |
| `d`     | Delete text |
| `i\`   | Insert text above the current line |
| `s`     | Search and replace text |

Example:
```bash
sed 's/old/new/g' file.txt  # Replaces 'old' with 'new' in file.txt
```
---

## 11. Awk
`awk` - searches files for lines or other text units containing one or more patterns.
When a line matches one of the patterns, special actions are performed on that line.

Helpful built-in variables:
| Variable | Description |
|----------|-------------|
| `$FS`    | Field separator |
| `$OFS`   | Output field separator |
| `$ORS`   | Output record separator |
| `$NR`    | Number of processed records |

```bash
ls -l | awk 'BEGIN {FS=":" ; print "Files found:\n"} /\<[a-z].*$/ { print $0} END { print "Thank you" }'
```
---

## 12. Conditional Statements

### If-Else Conditions
```bash
if [ -f "/file/path" ]; then
    echo "File exists."
elif [ -d "/dir/path" ]; then
    echo "It's a directory."
else
    echo "Not found."
fi
```

### Primary Operators
The table below contains an overview of the so-called "primaries" that make up the TEST-COMMAND command.
Primaries are put between square brackets to indicate the conditional expresion

| Primary | Meaning | 
|----------|-------------|
| [ -a FILE ] | True if FILE exists. |
| [ -d FILE ] | True if FILE exists and is a directory. |
| [ -e FILE ] | True if FILE exists. |
| [ -f FILE ] | True if FILE exists and is a regular file. |
| [ -r FILE ] | True if FILE exists and is readable. |
| [ -s FILE ] | True if FILE exists and has a size greater than zero. |
| [ -w FILE ] | True if FILE exists and is writable. |
| [ -x FILE ] | True if FILE exists and is executable. |
| [ -O FILE ] | True if FILE exists and is owned by the effective user ID. |
| [ -G FILE ] | True if FILE exists and is owned by the effective group ID. |
| [ -z STRING ] | True if the length of "STRING" is zero. |
| [ -n STRING ] or [ STRING ] | True if the length of "STRING" is non-zero. |
| [ STRING1 == STRING2 ] | True if the strings are equal. "=" may be used instead of "==" for strict POSIX compliance. |
| [ STRING1 != STRING2 ] | True if the strings are not equal. |
| [ STRING1 < STRING2 ]  | True if "STRING1" sorts before "STRING2" lexicographically in the current locale. |
| [ STRING1 > STRING2 ] | True if "STRING1" sorts after "STRING2" lexicographically in the current locale. |
| [ ARG1 OP ARG2 ] | "OP" is one of -eq, -ne, -lt, -le, -gt or -ge. These arithmetic binary operators return true if "ARG1" is equal to, not equal to, less than, less than or equal to, greater than, or greater than or equal to "ARG2", respectively. "ARG1" and "ARG2" are integers. |

### Combining Expressions
| Operation | Effect |
|----------|-------------|
| [ ! EXPR ] | True if EXPR is false. |
| [ ( EXPR ) ] | Returns the value of EXPR. This may be used to override the normal precedence of operators. |
| [ EXPR1 -a EXPR2 ] | True if both EXPR1 and EXPR2 are true. |
| [ EXPR1 -o EXPR2 ] | True if either EXPR1 or EXPR2 is true. |

### Logical Operators
| Operator | Description |
|----------|-------------|
| `&&` | AND (execute if previous is true) |
| `||` | OR (execute if previous is false) |

Example:
```bash
[ $? -eq 0 ] && echo "Success!" # Shorten version of casual if else statment
test $? -eq 0 && (echo 'That was a good job!') # Same effect using test built-in command
```

---
#TODO
## 13. Loops 

### For Loop
```bash
for i in 1 2 3; do
    echo "Iteration: $i"
done
```

### While Loop
```bash
n=0
while [ $n -lt 3 ]; do
    echo "Count: $n"
    ((n++))
done
```

### Until Loop
```bash
until [ "$done" = true ]; do
    echo "Still working..."
done
```

### Break & Continue
```bash
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        break  # Exit loop
    fi
    echo "$i"
done
```

---

## 8. Functions

### Define a Function
```bash
my_function() {
    echo "Hello from function!"
}
my_function  # Call function
```

### Pass Arguments
```bash
my_function() {
    echo "Parameter 1: $1"
}
my_function "Hello"
```

---

## 9. File Redirection & Piping

### Redirecting Output
| Operator | Description |
|----------|-------------|
| `>` | Redirect stdout (overwrite) |
| `>>` | Redirect stdout (append) |
| `2>` | Redirect stderr |
| `2>&1` | Redirect stderr to stdout |

Example:
```bash
echo "Hello" > file.txt  # Write to file
echo "New line" >> file.txt  # Append to file
ls nonexistent 2> errors.log  # Redirect errors
```

---

## 10. Useful Commands

### Grep
```bash
grep "pattern" file.txt  # Find pattern
grep -i "pattern" file.txt  # Case-insensitive search
```

### Sed
```bash
sed 's/old/new/g' file.txt  # Replace text
```

### Awk
```bash
awk '{print $1}' file.txt  # Print first column
```

### Sort
```bash
sort -n file.txt  # Numeric sort
```
