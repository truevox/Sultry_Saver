import time
import random
import microcontroller
import busio
import sys
import board
from adafruit_circuitplayground.express import cpx
from adafruit_circuitplayground.express import touchio

# dir(cpx.pixels) # contains useful info

# I am a modern monkey mans.

# NeoPixel color names
WHITE = (50, 50, 50)
OFF = (0, 0, 0)
RED = (255, 0, 0)
YELLOW = (255, 150, 0)
GREEN = (0, 255, 0)
CYAN = (0, 255, 255)
BLUE = (0, 0, 255)
PURPLE = (180, 0, 255)

# Not too bright!
cpx.pixels.brightness = 0.1

def Temp_convert(temp, unit):
    unit = unit.lower()
    if unit == "c":
        temp = 9.0 / 5.0 * temp + 32
        return temp #"%s degrees Fahrenheit"% temp
    if unit == "f":
        temp = (temp - 32)  / 9.0 * 5.0
        return temp #"%s degrees Celsius"% temp

def scale(val, src, dst):
    """
    Scale the given value from the scale of src (SouRCe) to the scale of dst (DeSTination).
    TODO: Make DocTests:
    #print scale(0, (0.0, 99.0), (-1.0, +1.0))
    #print scale(1, (0.0, 99.0), (-1.0, +1.0))
    #print scale(99, (0.0, 99.0), (-1.0, +1.0))
    """
    return ((val - src[0]) / (src[1]-src[0])) * (dst[1]-dst[0]) + dst[0]

 #print scale(0, (0.0, 99.0), (-1.0, +1.0))
 #print scale(1, (0.0, 99.0), (-1.0, +1.0))
 #print scale(99, (0.0, 99.0), (-1.0, +1.0))


# cpx.play_file("Coin.wav")   # Play a coin sound on boot

# Set up the accelerometer to detect tapping
cpx.detect_taps = 1    # detect single tap only

# Our counter for all 10 pixels
#pixeln = 0
# We can tell the switch changed
#last_switch = cpx.switch


#led = digitalio.DigitalInOut(board.D13)
#led.direction = digitalio.Direction.OUTPUT

# uart = busio.UART(board.TX, board.RX, baudrate=9600)

def DebugTrigger(x=cpx.switch):
    '''
    TODO: Give optional arg with default of cpx.switch
    Returns what ever switch triggers the "Debugging" code
    >>> DebugTrigger()
    cpx.switch
    >>> DebugTrigger(False)
    False
    '''
    return x

Touch_Debug_40 = touchio.TouchIn(board.A1)
Touch_Debug_65 = touchio.TouchIn(board.A2)
Touch_Debug_105 = touchio.TouchIn(board.A3)
Touch_Debug_115 = touchio.TouchIn(board.A4)
Touch_Debug_125 = touchio.TouchIn(board.A5)
Touch_Debug_145 = touchio.TouchIn(board.A6)
Touch_Debug_180 = touchio.TouchIn(board.A7)
Test_lights = cpx.pixels
Vent_Water = False
Temp_Source = cpx.temperature

# cpx.touchio.TouchIn

def Water_Temp_Setter(Temp_Source=cpx.temperature):
    '''
    Returns the water temp, based on cpx.temperature
    >>> x = Water_Temp_Setter()
    x < 250
    >>> x = Water_Temp_Setter()
    x > -20
    '''

    # Water_temp = (((Temp_convert(cpx.temperature,"c") * .05 ) * 4**5) - 4260)
    Set_Temp = Temp_convert(Temp_Source,"c")
    if My_Debug == True:
        if cpx.touch_A7:
            return 180.0
        elif cpx.touch_A6:
            return 145.0
        elif cpx.touch_A5:
            return 125.0
        elif cpx.touch_A4:
            return 115.0
        elif cpx.touch_A3:
            return 105.0
        elif cpx.touch_A2:
            return 65.0
        elif cpx.touch_A1:
            return 40.0
        else:
            return Set_Temp
    else:
        return Set_Temp




def Water_Temp_Indicator(Processed_Water_Temp):
    # Note to self, refactor this with elif statements that set a range of pixels
    if Processed_Water_Temp > 160.0:
        cpx.pixels[1] = RED
    else:
       cpx.pixels[1] = OFF
    if Processed_Water_Temp > 140.0:
        cpx.pixels[2] = RED
    else:
       cpx.pixels[2] = OFF
    if Processed_Water_Temp > 130.0:
        cpx.pixels[3] = RED
    else:
       cpx.pixels[3] = OFF
    if Processed_Water_Temp > 120.0:
        cpx.pixels[4] = YELLOW
    else:
       cpx.pixels[4] = OFF
    if Processed_Water_Temp > 110.0:
        cpx.pixels[5] = YELLOW
    else:
       cpx.pixels[5] = OFF
    if Processed_Water_Temp > 100.0:
        cpx.pixels[6] = PURPLE
    else:
       cpx.pixels[6] = OFF
    if Processed_Water_Temp > 80.0:
        cpx.pixels[7] = GREEN
    else:
       cpx.pixels[7] = OFF
    if Processed_Water_Temp > 60.0:
        cpx.pixels[8] = BLUE
    else:
       cpx.pixels[8] = OFF
    if Processed_Water_Temp > -160.0:
        cpx.pixels[9] = WHITE
    else:
        cpx.pixels[9] = OFF
    return

def Solenoid_Eval(Sol_Water_temp, Sol_Fill_heat):
    '''
    Evaluates whether the solenoid on the 3way pipe should trigger.
    Returns True if solenoid should be unpowered, or False if the solenoid
    should be powered.
    >>> Solenoid_Eval(100, 120)
    Alert - Drain Open!
    True
    >>> Solenoid_Eval(140, 120)
    False
    >>> Solenoid_Eval(120, 120)
    False
    >>> Solenoid_Eval(a, 1)
    Traceback (most recent call last):
     ...
    NameError: name 'a' is not defined
    '''
    if Sol_Water_temp >= Sol_Fill_heat:
        Vent_Water = False
    else:
        Vent_Water = True
    return Vent_Water

def Solenoid_Trigger(VentBool):
    if VentBool:
        cpx.red_led = True
        return str("Alert - Drain Open!")
    elif VentBool == False:
        cpx.red_led = False
    else:
        print("ERROR!!!")
        return  # TODO: Need to figure out raising exceptions
    return

TicksTween = 10
TimeClock = 0
RepeatTicker = 0

def Time_Ticker(Ticks, pTicksTween):
    Ticks = Ticks + 1
    if Ticks >= pTicksTween:
        Ticks = 0
        if My_Debug: print("Tick Rollover")
    return Ticks


while True:

    My_Debug = DebugTrigger() # Leave DebugTrigger() blank to power it with the on-board switch.

    Water_temp = Water_Temp_Setter(cpx.temperature)
    #if My_Debug: Water_temp = scale(Water_temp, (80.0, 90.0), (60.0, 160.0))
    #if My_Debug: print("Fake Temp: " + str(Water_temp))

    if My_Debug: Water_Temp_Indicator(Water_temp)
    else:
        for i in range(len(cpx.pixels)):
            cpx.pixels[i] = OFF

    Fill_heat = 120

    Solenoid_Trigger(Solenoid_Eval(Water_temp, Fill_heat))

    if My_Debug == True:
        time.sleep(0.3)
    else:
        time.sleep(10)
    print(str(Water_temp) + "  " + str(RepeatTicker))
    RepeatTicker = RepeatTicker + 1
    TimeClock = Time_Ticker(TimeClock, TicksTween)
    if TimeClock % TicksTween == 0:
        print("Debugging is set to " + str(My_Debug) + " and temp readings may be " + str(not My_Debug))
        print(str(Solenoid_Trigger(Solenoid_Eval(Water_temp, Fill_heat))))
    if TimeClock % TicksTween == 5: print(str(Solenoid_Trigger(Solenoid_Eval(Water_temp, Fill_heat))))
    #print(Time_Ticker(TimeClock, TicksTween))
    #print(TimeClock % TicksTween)



    # loop to the beginning!
