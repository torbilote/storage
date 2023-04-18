Syntax:
Name of variable, class, function or module has to start with a letter A-Z/a-z or underscore followed by zero or more letters, underscores and digits.
Python does not support characters like @, $ and %.

All names should start with lowercase except class names (according to convention).

If the name starts with underscore, it means it is intended to be used only within the function, class or module.
Also "from M import *" will not import functions with leading underscore.
One trailing underscore is used to avoid naming conflicts with Python keywords.
Two leading underscores are mainly used within a class. Python converts variablename to _classname__variablename to prevent accidental access to it.
Two leading underscores and two trailing underscores are reserved for builtin methods/variables.

Python allows mutli-line statements ("\" char at the end of the line) to denote that the line should continue.
The char is not needed when statement is within brackets.

Python accepts triple quotes to have multi-line string literals.

"#" char for one line comment
" ''' " chars to start/end multi-line comment (tripple single quiots).

You can insert more than one statement in single line separating them by semicolon.


Data Types:
Primitive:

Numbers:
1+1, 1-1, 10*2, 35/5 - basic operations
5//3 - rounded down to integer
7%3 - modulo
2**3 - exponentiation

Boolean:
True, False - capitalization
not True - negate with "not"
"and" and "or" - boolean operators, "&" and "|" is not an alternative for "and" and "or"
True == 1
False == 0
Falsy values: None, 0, empty strings,lists,dicts,tuples,sets ('', [], {})
Truthy values: All other

1 < 2 and 2 < 3 you can make it nicer by chaining to 1 < 2 < 3

"is" checks if two variables refer to the same object.
"==" checks if objects pointed to have the same value.

"in" checks if existance of an object in list.

Strings:
Can be added like 'aaa' + 'bbb'
If only literals, can be concatenated without "+" like 'aaa' 'bbb'

String is treated as a set of characters.
F-strings since 3.6 - expressions nested within string.
Immutable. Cannot change an element of the string.

None is an object.

There is one line if else expression works as ternary operator
'aaa' if 1 > 0 else 'bbb'

Collections:

Lists - set of elements ordered. Mutable (it means you can modify its' elements).
Tuples - like lists but immutable.
Dictionaries - store mappings from keys to values. Mutable however keys have to be immutable type to ensure key can be converted to a constant hash value for quick look-ups. These are numbers, strings and tuples. Order of elements is kept starting from Python 3.7.
Sets - Mutable however elements have to be immutable type, order is not kept. There cannot be duplicated values within set.

















