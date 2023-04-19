# ---Basics---
text1 = "Text from line one, " + "Text from line two, " + "Text from line three."
text2 = ["Text from line one, ", "Text from line two, ", "Text from line three."]
text3 = "Text from line o\
        ne and two"
# Comment
"""Also Comment
"""
print("First statement")
print("Second statement")

# -- Integers --
integer1 = 1000000000000244982325035 + 1
integer2 = 0b10

# -- Floats --
float1 = 4.2242104210140
float2 = 1.79e308


# -- Booleans --
assert True is 1
assert False is 0

# -- Strings --
string1 = "Hel\nlo"
string2 = r"Hel\nlo"
string3 = "{str!s} World!".format(str=string1)
string4 = "Age of {num:e}".format(num=integer1)
string5 = "Num {num:.5f}".format(num=float1)


# --- Lists ---
list1 = []
list2 = [1, 2, 3, 5]
list(list1)
# append to the end
list1.append(7)
# insert
list1.insert(1, 5)
# remove from given position or from the end if no arg
list1.pop()
# remove first occurance of a value
list1.remove(1)
# accessing
list1[2]
list1[-1]
list1[1:2:1]
# modify its element - proof of being mutable
list1[1] = 5
# copy?
list3 = list1[:]
# delete element
del list1[2]
# add two lists
list1 + list2
# extend list with values from naother list
list1.extend(list2)
# check if value exists in list
1 in list1
# get length of list
len(list1)
# count occurance of an object in list
list1.count(2)
# reverse list
list1.reverse()
# unpacking list to variables
a, b, c = [1, 2, 3]
a, b, *c = [1, 2, 3, 5, 6, 7, 8]
# swap two values
a, b = b, a

# --- Tuples ---
tuple1 = ()
tuple2 = (5, 6, 7, 8)
# accessing as in lists
tuple2[0]
tuple2[-1]

# --- Dictionaries ---
dict1 = {}
dict2 = {"a": 1, "b": 2}
dict3 = {(1, 2): 1}
# access via key in bracket
dict2["a"]
dict2["b"] = 3
# getting all keys, all values. For efficiency, it is much better to iterate through dict itself.
dict2.keys()
dict2.values()
# check occurance within keys
"a" in dict2
# try to get key value, if none, throws an error
dict2["c"]
# try same but if none, default value is returned
dict2.get("c", None)
# insert into dict only if key doesnt exist
dict2.setdefault("c", 4)
# adding new pair to dict
dict2.update({"d": 5})
dict2["d"] = 5
# unpacking
dict2 = {"q": 1, **dict}

# --- Sets ---
set1 = set()
set2 = {1, 2, 3, 4, 5}
# Add element
set2.add(6)
set2.add(6)
# Set intersection
a = {1, 2}
b = {2, 3}
a & b
# Set union
a | b
# Set difference
a - b
# Symmetric difference
a ^ b
# Check if set on the left is a superset of the set on the right
a >= b

# --- Conditional statements & Loops ---
command = "go"
match command:
    case "stop":
        print("stop")
    case "go":
        print("go")
    case other:
        #     case _:
        print("other")

# --- Built-in functions ---
bin(233)
bool(1)
int(5, base=10)
str(5)
type("1")
all([1, 1, 1, 0])
any([1, 1, 1, 0])
enumerate([1, 1])
len([])
range(50, 100, 2)
reversed([1, 2, 3])
sorted([5, 6, 2])
dict([("a", 1), ("b", 2)])
list((1, 2, 3, 5))
set([1, 2, 3, 4, 5, 6])
tuple([1, 2, 3])
isinstance("a", str)
input("Hello")
with open(file="dupa.csv", mode="r") as f:
    f.readlines()
print("a", "b", "c", sep=";", end="!")
callable(lambda x: x+2)


