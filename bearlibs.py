'''
This is a library file, but this docstring will ALSO contain what ever
useful reference code I can think of

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if foo == 'abc' and bar == 'bac' or zoo == '123':
  # do something

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> from collections import deque
>>> queue = deque(["Eric", "John", "Michael"])
>>> queue.append("Terry")           # Terry arrives
>>> queue.append("Graham")          # Graham arrives
>>> queue.popleft()                 # The first to arrive now leaves
'Eric'
>>> queue.popleft()                 # The second to arrive now leaves
'John'
>>> queue                           # Remaining queue in order of arrival
deque(['Michael', 'Terry', 'Graham'])

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

'''


def Time_Ticker(Ticks, pTicksTween, IsDebugOn):
    '''
    Ticks is a unit of incremented time, pTicksTween is
    the number of ticks between "rollover".
    #TODO Setup some tests (should be pretty simple)
    '''
    Ticks = Ticks + 1
    if Ticks >= pTicksTween:
        Ticks = 0
        #if IsDebugOn: print("Tick Rollover")
    return Ticks
