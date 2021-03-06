#!/usr/bin/env python3

# modified version of the SafeShutdown.pu file from https://github.com/RetroFlag/retroflag-picase/blob/master/SafeShutdown_gpi.py
# this version is for the raspbian partition of a dual booting gpi case
# uses subprocess.call func instead of os.system, and works even when X is not running

from gpiozero import Button, LED
import subprocess 
from signal import pause

powerPin = 26 
powerenPin = 27 
hold = 1
power = LED(powerenPin)
power.on()

#functions that handle button events
def when_pressed():
        subprocess.call('sudo killall "startx"', shell=True)
        subprocess.call('sudo shutdown -h "now"', shell=True)
  
btn = Button(powerPin, hold_time=hold)
btn.when_pressed = when_pressed
pause()
