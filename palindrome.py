from z3 import *

def arr_eq(a, b, l1, l2):
    return And([l1 == l2] + [a[i] == b[i] for i in range(l1)])

def reverse_arr(a, b, l):
    return And([a[i] == b[l - i - 1] for i in range(l)])

def palindrome(a, l, rev_name='b'):
    b = Array(rev_name, IntSort(), IntSort())
    return And([reverse_arr(a, b, l), arr_eq(a, b, l, l)])

s = Solver()
a = Array('a', IntSort(), IntSort())

# add input str
teststr = 'racecat'
for (i, c) in enumerate(teststr): s.add(a[i] == ord(c))

# get reversed str (not necessary for actual palindrome check)
rev_a = Array('rev_a', IntSort(), IntSort())
s.add(reverse_arr(a, rev_a, len(teststr)))
s.check()
m = s.model()
py_rev_a = ''.join(chr(m.eval(rev_a[i]).as_long()) for i in range(len(teststr)))

print(f"reversed: {py_rev_a}")

s.add(palindrome(a, len(teststr)))

if s.check() == sat:
    print("is palindrome")
else:
    print("not palindrome")
