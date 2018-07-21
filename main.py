import time
# import random
# import microcontroller
# import busio
import sys
import board
import bearlibs
from adafruit_circuitplayground.express import cpx
from adafruit_circuitplayground.express import touchio


# dir(cpx.pixels) # contains useful info

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

def wheel(pos):
    # Input a value 0 to 255 to get a color value.
    # The colours are a transition r - g - b - back to r.
    if pos < 0 or pos > 255:
        return 0, 0, 0
    if pos < 85:
        return int(255 - pos * 3), int(pos * 3), 0
    if pos < 170:
        pos -= 85
        return 0, int(255 - pos * 3), int(pos * 3)
    pos -= 170
    return int(pos * 3), 0, int(255 - (pos * 3))

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
    #TODO: Make DocTests:
    #print scale(0, (0.0, 99.0), (-1.0, +1.0))
    #print scale(1, (0.0, 99.0), (-1.0, +1.0))
    #print scale(99, (0.0, 99.0), (-1.0, +1.0))
    """
    return ((val - src[0]) / (src[1]-src[0])) * (dst[1]-dst[0]) + dst[0]


# Set up the accelerometer to detect tapping
cpx.detect_taps = 1    # detect single tap only



# uart = busio.UART(board.TX, board.RX, baudrate=9600)



Test_lights = cpx.pixels
Vent_Water = False
Temp_Source = cpx.temperature

# cpx.touchio.TouchIn

def Water_Temp_Setter(Temp_Source=cpx.temperature):   #TODO Make it return a running average of 10 temps using list.
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
Water_temp = 1
Prev_Water_Temp = 0
High_Water_Temp = 70
Fill_heat = 120
Start_Reading = 0
Running_Temp = [80, 80, 80, 80, 80, 80, 80, 80, 80, 80]
Solenoid_Trigger(False)
Should_Vent_Be_Open = False

High_Water_Temp_Counter_Reps = 36000  # 900000 = 10*60*60*25 (decisecond*60 seconds in minute * 60 minutes in hour * 25 Hours, 36000 = 1 Hr)
Failsafe_Timer_Reps = 1500  # 1500 amounts to 2½ minutes
Hot_Water_Not_Changing_Timer_Reps = 60 # 60 amounts to 6 seconds
Debug_Looper_Reps = 10
Debug_Loopper = Debug_Looper_Reps

High_Water_Temp_Counter = High_Water_Temp_Counter_Reps
Failsafe_Timer = Failsafe_Timer_Reps
Hot_Water_Not_Changing_Timer = Hot_Water_Not_Changing_Timer_Reps




while True:

    My_Debug = cpx.switch

    if cpx.button_a: # cpx.leftButton():       # CircuitPlayground.leftButton()
        Start_Reading = 1

    if My_Debug == True:
        time.sleep(0.2)
        Debug_Loopper -= 1
        if Debug_Loopper <= 0:
            print("Water Temp: " + str(Water_temp) + ", High Temp: " + str(High_Water_Temp))
            Debug_Loopper = Debug_Looper_Reps
    else:
        time.sleep(0.1)

    if Start_Reading == 1:
        if Water_temp < High_Water_Temp - 10 and Should_Vent_Be_Open == False:
            Solenoid_Trigger(True)
            Should_Vent_Be_Open = True

        if Failsafe_Timer >= 0:
            Failsafe_Timer -= 1     #Deincrement Failsafe down by one
        else:
            Failsafe_Timer = Failsafe_Timer_Reps
            Solenoid_Trigger(False)
            Should_Vent_Be_Open = False
            Start_Reading = 0

        Prev_Water_Temp = Water_temp
        Water_temp = Water_Temp_Setter(cpx.temperature) # Sets the Water_temp in Fahrenheit. #TODO Make it return a running average of say 10 temps.
        Running_Temp.pop(0)
        Running_Temp.append(Water_temp)
        Water_temp = sum(Running_Temp) / float(len(Running_Temp))   # Could be sum(l) / len(l) if I wanted to keep it int

        if High_Water_Temp_Counter <= 0:
            High_Water_Temp -= 1
            High_Water_Temp_Counter = High_Water_Temp_Counter_Reps
            Hot_Water_Not_Changing_Timer = Hot_Water_Not_Changing_Timer_Reps

        if ((High_Water_Temp + 1 ) < Water_temp):
            High_Water_Temp = High_Water_Temp + (0.2*(abs(High_Water_Temp - Water_temp)))
            High_Water_Temp_Counter = High_Water_Temp_Counter_Reps
            Hot_Water_Not_Changing_Timer = Hot_Water_Not_Changing_Timer_Reps
        else:
            High_Water_Temp_Counter -= 1
            Hot_Water_Not_Changing_Timer -= 1

        if Hot_Water_Not_Changing_Timer <= 0:
            Solenoid_Trigger(False)
            Should_Vent_Be_Open = False
            Hot_Water_Not_Changing_Timer = Hot_Water_Not_Changing_Timer_Reps


        #if My_Debug: Water_temp = scale(Water_temp, (80.0, 90.0), (60.0, 160.0))
        #if My_Debug: print("Fake Temp: " + str(Water_temp))

        if My_Debug: Water_Temp_Indicator(Water_temp)
        else:
            for i in range(len(cpx.pixels)):
                if i == 2:
                    cpx.pixels[i] = wheel(int(Water_temp))
                elif i == 7:
                    cpx.pixels[i] = wheel(int(High_Water_Temp))
                else:
                    cpx.pixels[i] = OFF




        Solenoid_Trigger(Solenoid_Eval(Water_temp, Fill_heat))


        RepeatTicker = RepeatTicker + 1
        TimeClock = bearlibs.Time_Ticker(TimeClock, TicksTween, My_Debug)
        if TimeClock % TicksTween == 0:
            print("Debugging is set to " + str(My_Debug) + " and temp readings may be " + str(not My_Debug))
            print(str(Solenoid_Trigger(Solenoid_Eval(Water_temp, Fill_heat))))
        if TimeClock % TicksTween == 5: print(str(Water_temp) + "   " + str(RepeatTicker))
        #if TimeClock % TicksTween == 5: print(str(Solenoid_Trigger(Solenoid_Eval(Water_temp, Fill_heat))))
        #print(bearlibs.Time_Ticker(TimeClock, TicksTween, My_Debug))
        #print(TimeClock % TicksTween)





    # loop to the beginning!
