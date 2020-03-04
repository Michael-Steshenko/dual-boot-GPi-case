# this script runs xboxdrv and configures the GPi controls to act like a mouse
# dpad moves mouse
# a is left click
# b is right click
# x is mouse middle button
# y is enter key
# lb is arrow up (useful for terminal)
# rb is arrow down (useful for terminal)
# start is key forward
# select is escape

sudo rmmod xpad
sudo xboxdrv --ui-buttonmap "dr=REL_X:5:20,dl=REL_X:-5:20,du=REL_Y:-5:20,dd=REL_Y:5:20," --ui-buttonmap "a=BTN_LEFT,b=BTN_RIGHT,x=BTN_MIDDLE,y=KEY_ENTER,rb=KEY_DOWN,lb=KEY_UP," --ui-buttonmap "start=KEY_FORWARD,back=KEY_ESC,tl=void,tr=void"
