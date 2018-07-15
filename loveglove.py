witch
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
        cpx.red_led = 