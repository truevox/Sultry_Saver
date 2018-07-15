import time
import random
import microcontroller
from adafruit_circuitplayground.express import cpx


# This is a special command that will cause a single-press RESET to go
# into bootloader more (instead of double-click) to make it easier for
# MakeCode-rs who don't intend to use CircuitPython!
# microcontroller.on_next_reset(microcontroller.RunMode.BOOTLOADER)

# Set this to True to turn on the capacitive touch tones
TOUCH_PIANO = True

# NeoPixel color names
WHITE = (50, 50, 50)
OFF   = (0,   0,  0)

# Not too bright!
cpx.pixels.brightness = 0.3

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

cpx.play_file("Coin.wav")   # Play a coin sound on boot

# Set up the accelerometer to detect tapping
cpx.detect_taps = 1    # detect single tap only

# Our counter for all 10 pixels
pixeln = 0
# We can tell the switch changed
last_switch = cpx.switch

while True:
    cpx.red_led = True                  # Turns the little LED next to USB on

    #cpx.pixels[1] = 100

    if TOUCH_PIANO:
        if cpx.touch_A4:              #  If we set to play tones
            cpx.pixels[1] = 50 # cpx.start_tone(524)
        elif cpx.touch_A5:
            cpx.pixels[2] = 100 # cpx.start_tone(588)
        elif cpx.touch_A6:
            cpx.pixels[3] = 125 # cpx.start_tone(660)
        elif cpx.touch_A7:
            cpx.pixels[4] = 150 # cpx.start_tone(698)
        elif cpx.touch_A1:
            cpx.pixels[5] = 175 # cpx.start_tone(784)
        elif cpx.touch_A2:
            cpx.pixels[6] = 200 # cpx.start_tone(880)
        elif cpx.touch_A3:
            cpx.pixels[7] = 225 # cpx.start_tone(988)
        else:
            for p in range(10):     #cpx.stop_tone()           # nothing touched? turn off the audio
                #color = wheel(25 * ((pixeln + p)%10))
                cpx.pixels[p] = 0
                # Every time we go around, print sensor data
                print("Temperature: %0.1f *C" % cpx.temperature)
                print("Light Level: %d" % cpx.light)
                x, y, z = cpx.acceleration
                print("Accelerometer: (%0.1f, %0.1f, %0.1f) m/s^2" % (x, y, z))
                print('-' * 40)

    # loop to the beginning!