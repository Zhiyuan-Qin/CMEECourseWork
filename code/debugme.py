#!/usr/bin/env python3

"""Demonstrate debugging and handling division by zero."""

def buggyfunc(x):
    y = x
    for i in range(x):
        try:
            y = y-1
            z = x/y
        except ZeroDivisionError:
            print(f"The result of dividing a number by zero is undefined")
        except:
            print(f"This didn't work;{x = }; {y = }")
        else:
            print(f"OK; {x = }; {y = }, {z = };")
    return z

if __name__ == "__main__":
    buggyfunc(20)
