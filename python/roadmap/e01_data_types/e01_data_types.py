text_variable = "Text from line one, " + \
                "Text from line two, " + \
                "Text from line three."

text_variable_in_list = ["Text from line one, ",
                                "Text from line two, ",
                "Text from line three."]

print(text_variable,
      text_variable_in_list,
      sep='\n')

# Cool
'''Also
    Cool
'''

print('a');print('b')




# Lists:
lst = []
lst = [1,2,3,5]
list(lst)
# append to the end
lst.append(7)
# insert
lst.insert(1,5)
# remove from given position or from the end if no arg
lst.pop()
# remove first occurance of a value
lst.remove(1)
# accessing
lst[2]
lst[-1]
lst[1:2:1]
# modify its element - proof of being mutable
lst[1] = 5
# copy?
lst2 = lst[:]
# delete element
del lst[2]
# add two lists
lst + lst2
# extend list with values from naother list
lst.extend(lst2)
# check if value exists in list
1 in lst
# get length of list
len(lst)
# count occurance of an object in list
lst.count(2)
# reverse list
lst.reverse()
# unpacking list to variables
a,b,c = [1,2,3]
a,b,*c = [1,2,3,5,6,7,8]
# swap two values
a, b = b, a

# Tuples
tpl = ()
tpl = (5,6,7,8)
# accessing as in lists
tpl[0]
tpl[-1]

# Dictionaries
dct = {}
dct = {"a": 1, "b": 2}
dct2 = {(1,2): 1}
# access via key in bracket
dct["a"]
dct["b"] = 3
# getting all keys, all values. For efficiency, it is much better to iterate through dict iself.
dct.keys()
dct.values()
# check occurance within keys
"a" in dct
# try to get key value, if none, throws an error
dct["c"]
# try same but if none, default value is returned
dct.get("c", None)
# insert into dict only if key doesnt exist
dct.setdefault("c", 4)
# adding new pair to dict
dct.update({"d":5})
dct["d"] = 5
# unpacking
dct2 = {'q':1, **dct}

# Sets
st = set()
st = {1,2,3,4,5}
# Add element
st.add(6)
st.add(6)
# Set intersection
a = {1,2}
b = {2,3}
a & b
# Set union
a | b
# Set difference
a - b
# Symmetric difference
a ^ b
# Check if set on the left is a superset of the set on the right
a >= b
