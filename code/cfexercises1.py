
def foo_1(x):
    """Input a non-negative number and return its square root."""
    return x ** 0.5

def foo_2(x, y):
    """Return the larger of two numbers."""
    if x > y:
        return x
    return y

def foo_3(x, y, z):
    """Return the three numbers in ascending order."""
    if x > y:
        x, y = y, x
    if x > z:
        x, z = z, x
    if y > z:
        y, z = z, y
    return [x, y, z]

def foo_4(x):
    """Input a non-negative integer and return its factorial. Use a for loop to calculate the factorial."""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x): # a recursive function that calculates the factorial of x
    """Input a non-negative integer and return its factorial. Use recursion to calculate the factorial."""
    if x == 1 or x == 0:
        return 1
    return x * foo_5(x - 1)

def foo_6(x): # Calculate the factorial of x in a different way; no if statement involved
    """Input a non-negative integer and return its factorial. Use a while loop to calculate the factorial."""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

if __name__ == "__main__":
    print(foo_1(9))
    print(foo_2(3, 8))
    print(foo_3(3, 1, 2))
    print(foo_4(5))
    print(foo_5(5))
    print(foo_6(5))
    print(foo_4(0))
    print(foo_5(0))
    print(foo_6(0))
