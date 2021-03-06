import time
import random
import microcontroller
import busio
import sys
import board
from adafruit_circuitplayground.express import cpx


#try:
#    # your code
#except KeyboardInterrupt:
#    sys.exit(0) # or 1, or whatever

# This is a special command that will cause a single-press RESET to go
# into bootloader more (instead of double-click) to make it easier for
# MakeCode-rs who don't intend to use CircuitPython!
# microcontroller.on_next_reset(microcontroller.RunMode.BOOTLOADER)

# Set this to True to turn on the capacitive touch tones
My_Debug = True

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
cpx.pixels.brightness = 0.5

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


Test_lights = cpx.pixels

while True:

    while My_Debug:
        My_Debug = cpx.switch
        cpx.pixels.fill((0,0,0))
        Water_temp = (((Temp_convert(cpx.temperature,"c") * .05 ) * 4**5) - 4260)
        if cpx.touch_A4:
            Water_temp = 150.0
        if cpx.touch_A2:
            Water_temp = 50.0

        if Water_temp > -160.0:
            cpx.pixels[0] = WHITE
           # Test_lights[0] = WHITE
           # Test_lights[1:9] = OFF
        if Water_temp > 60.0:
            cpx.pixels[1] = BLUE
           # Test_lights[2] = WHITE
           # Test_lights[2:] = OFF
        if Water_temp > 80.0:
            cpx.pixels[2] = GREEN
        if Water_temp > 100.0:
            cpx.pixels[3] = PURPLE
        if Water_temp > 110.0:
            cpx.pixels[4] = YELLOW
        if Water_temp > 120.0:
            cpx.pixels[5] = YELLOW
        if Water_temp > 130.0:
            cpx.pixels[6] = RED
        if Water_temp > 140.0:
            cpx.pixels[7] = RED
        #else:
        #    cpx.pixels.fill = RED
        time.sleep(1)
        print(Water_temp)
        print(My_Debug)

        if Water_temp > 120:
            cpx.red_led = True
        elif Water_temp <= 120:
            cpx.red_led = False


    while My_Debug != True:
        Water_temp = Temp_convert(cpx.temperature,"c")
        if Water_temp > -160.0:
            cpx.pixels[0] = WHITE
           # Test_lights[0] = WHITE
           # Test_lights[1:9] = OFF
        if Water_temp > 60.0:
            cpx.pixels[1] = BLUE
           # Test_lights[2] = WHITE
           # Test_lights[2:] = OFF
        if Water_temp > 80.0:
            cpx.pixels[2] = GREEN
        if Water_temp > 100.0:
            cpx.pixels[3] = PURPLE
        if Water_temp > 110.0:
            cpx.pixels[4] = YELLOW
        if Water_temp > 120.0:
            cpx.pixels[5] = YELLOW
        if Water_temp > 130.0:
            cpx.pixels[6] = RED
        if Water_temp > 140.0:
            cpx.pixels[7] = RED
        time.sleep(1)
        print(Water_temp)
        print(My_Debug)
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
    #cpx.pixels[1] = 100


    # loop to the beginning!'''