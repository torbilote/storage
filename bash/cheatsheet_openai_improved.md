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
- **bash** (Bourne Again Shell) – Standard shell in Linux, compatible with `sh`.

### Check Available Shells
```bash
cat /etc/shells
```

### Check Default Shell
```bash
cat /etc/passwd | grep "$USER"
```

### Switching Shells
Type the shell name (e.g., `bash`, `sh`, `zsh`). The system finds and executes it using the `$PATH` variable.

### Interactive vs. Non-Interactive Shells
- **Interactive**: Accepts user input via a terminal.
- **Non-Interactive**: Executes commands from a script.

Check if a shell is interactive:
```bash
echo $-
```

---

## 2. Bash Built-in Commands

### Types of Commands
1. **sh Built-in Commands**: `cd`, `exit`, `export`, `pwd`, `readonly`, `set`, etc.
2. **bash Built-in Commands**: `alias`, `bind`, `command`, `declare`, `echo`, `help`, `printf`, `read`, `ulimit`, etc.
3. **POSIX Special Built-in Commands**: Used in strict POSIX mode.

---

## 3. Running Scripts

### Script Execution
- Bash scripts start with `#!` (shebang) followed by the interpreter path:
  ```bash
  #!/bin/bash
  ```
- Run a script:
  ```bash
  ./script.sh  # Uses the shell defined in the shebang
  bash script.sh  # Uses the shell from the command line
  ```
- Run in the current shell:
  ```bash
  source script.sh  # Bash notation
  . script.sh       # sh notation
  ```

### Debugging Scripts
- Execute with debugging:
  ```bash
  bash -x script.sh
  ```
- Debug specific sections:
  ```bash
  set -x
  echo "Debugging..."
  set +x
  ```

---

## 4. Variables

### Types of Variables
- **Global (Environment) Variables**: Available in all shells.
- **Local Variables**: Available only in the current shell.

### Creating Variables
```bash
VARNAME="value"  # No spaces around =
export VARNAME   # Make it global
```

### Display Variables
```bash
printenv  # Show environment variables
set       # Show all variables
```

### Special Variables
| Variable | Description |
|----------|-------------|
| `$0` | Script name |
| `$1`, `$2`, ... | Positional parameters |
| `$*` | All positional parameters as a single string |
| `$@` | All positional parameters as separate words |
| `$#` | Number of positional parameters |
| `$$` | PID of the shell |
| `$!` | PID of the last background command |
| `$?` | Exit status of the last executed command |

---

## 5. String Operations

### Quoting Mechanisms
- **Single Quotes (`'`)**: Preserves literal value.
- **Double Quotes (`"`)**: Preserves all characters except `$`, `"`, and ``\``.
- **Backticks (`` `command` ``) / `$(command)`**: Command substitution.

```bash
echo "Hello $(date)"
```

---

## 6. Conditional Statements

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

### Logical Operators
| Operator | Description |
|----------|-------------|
| `&&` | AND (execute if previous is true) |
| `||` | OR (execute if previous is false) |

Example:
```bash
[ $? -eq 0 ] && echo "Success!"
```

---

## 7. Loops

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

---

## Notes
- **(Original Notes)**: Content taken directly from the user's notes.
- **(Added Content)**: Supplementary explanations and examples added for clarity.

---

This structured Bash cheatsheet is now ready for use! 🚀
