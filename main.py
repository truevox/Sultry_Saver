import time
import random
import microcontroller
import busio
import sys
import board
from adafruit_circuitplayground.express import cpx
from adafruit_circuitplayground.express import touchio


#try:
#    # your code
#except KeyboardInterrupt:
#    sys.exit(0) # or 1, or whatever

# This is a special command that will cause a single-press RESET to go
# into bootloader more (instead of double-click) to make it easier for
# MakeCode-rs who don't intend to use CircuitPython!
# microcontroller.on_next_reset(microcontroller.RunMode.BOOTLOADER)

# Set this to True to turn on the capacitive touch tones

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
    if (pos < 0) or (pos > 255):
        return (0, 0, 0)
    if pos < 85:
        return (int(255 - pos*3), int(pos*3), 0)
    elif pos < 170:
        pos -= 85
        return (0, int(255 - (pos*3)), int(pos*3))
    else:
        pos -= 170
    return (int(pos*3), 0, int(255 - pos*3))
    
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
    """
    return ((val - src[0]) / (src[1]-src[0])) * (dst[1]-dst[0]) + dst[0]

 #print scale(0, (0.0, 99.0), (-1.0, +1.0))
 #print scale(1, (0.0, 99.0), (-1.0, +1.0))
 #print scale(99, (0.0, 99.0), (-1.0, +1.0))


cpx.play_file("Coin.wav")   # Play a coin sound on boot

# Set up the accelerometer to detect tapping
cpx.detect_taps = 1    # detect single tap only

# Our counter for all 10 pixels
pixeln = 0
# We can tell the switch changed
last_switch = cpx.switch


#led = digitalio.DigitalInOut(board.D13)
#led.direction = digitalio.Direction.OUTPUT
 
uart = busio.UART(board.TX, board.RX, baudrate=9600)

def DebugTrigger():
    '''Returns what ever switch triggers the "Debugging" code
    >>> DebugTrigger()
    cpx.switch
    '''
    return cpx.switch

Touch_Debug_40 = touchio.TouchIn(board.A1)
Touch_Debug_65 = touchio.TouchIn(board.A2)
Touch_Debug_105 = touchio.TouchIn(board.A3)
Touch_Debug_115 = touchio.TouchIn(board.A4)
Touch_Debug_125 = touchio.TouchIn(board.A5)
Touch_Debug_145 = touchio.TouchIn(board.A6)
Touch_Debug_180 = touchio.TouchIn(board.A7)
Test_lights = cpx.pixels

# cpx.touchio.TouchIn



def Water_Temp_Setter():
    # Water_temp = (((Temp_convert(cpx.temperature,"c") * .05 ) * 4**5) - 4260)
    Set_Temp = Temp_convert(cpx.temperature,"c")
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




while True:
    
    My_Debug = DebugTrigger()

    Water_temp = Water_Temp_Setter()

    if My_Debug: Water_Temp_Indicator(Water_temp)
    else:
        for i in range(len(cpx.pixels)):
            cpx.pixels[i] = OFF

    if Water_temp > 120:
        cpx.red_led = True
    elif Water_temp <= 120:
        cpx.red_led = False

    time.sleep(0.25)
    print(Water_temp)
    print("Debugging is set to", My_Debug, "and temp readings may be", not My_Debug)
    cpx.pixels.fill = OFF
    
    if Water_temp > 120:
        cpx.red_led = True
    elif Water_temp <= 120:
        cpx.red_led = False





    '''
    data = uart.read(32)  # read up to 32 bytes
    # print(data)  # this is a bytearray type
 
    if data is not None:
        cpx.red_led = True
 
        # convert bytearray to string
        data_string = ''.join([chr(b) for b in data])
        print(data_string, end="")
 
        cpx.red_led = False



 #   data = sys.stdin.read(1)
    if data == 1:
        cpx.red_led = True

    elif data != 0:
        cpx.red_led = False





    #cpx.red_led = True                  # Turns the little LED next to USB on
    # if cpx.



    # loop to the beginning!'''
#=======
#print("Hello World!"
#>>>>>>> master