# pwm_controller
PWM controller with a uart command module and a python script with GUI.

To set pwm duty send 0x43 via the serial port followed by a byte for the duty setting, 0 to 255, 8 bit res set by default. 
This repo also includes a simple python script to set the duty cycle. 
