#Created By: Osman Ahmed
#Description: Simple gui to control pwm

import tkinter as tk
import requests, json

import serial as ser
import time
import binascii

master_window = tk.Tk()
master_window.title("PWM Controller")
master_window.geometry("500x500")
pwm_set_cmd= 67  # ascii C: cmd to set pwm
arty_ser = ser.Serial(port="COM10", baudrate=9600, bytesize=8, timeout=2, stopbits=ser.STOPBITS_ONE)

def close_func():
    print("closing port")
    arty_ser.close() # close the serial port before exiting!

def send_duty_func():

    ser_data= int(pwm_data_entry.get())
    print("data entered:", ser_data)
    pwm_duty =  ser_data & 0xFF # ADD PADDING and max range checking
    if pwm_duty <=25.5: # will limit on time to 2ms (mg995 servo)

        cmd_set_pwm= bytes([pwm_set_cmd])
        print("cmd is:", cmd_set_pwm)
        pwm_duty_bytes=bytes([pwm_duty])
        print("pwm duty in bytes is",pwm_duty_bytes)

        arty_ser.write(cmd_set_pwm)
        time.sleep(0.1)
        arty_ser.write(pwm_duty_bytes)
        time.sleep(0.1)

    else:

        print("duty out of range ")


    if (arty_ser.in_waiting > 0):
        serialString = arty_ser.readline()

        print(serialString.decode('utf-8'))
        #data_lab_text.set(serialString.decode('utf-8'))


######################

send_pwmduty_button = tk.Button(master_window, text="Send PWM duty", command=lambda: send_duty_func())
send_pwmduty_button.grid(row=6, column=0, padx=5, pady=5)

pwm_data_entry = tk.Entry(master_window, fg="black", bg="white", width=20)
pwm_data_entry.grid(row=5, column=0, padx=5, pady=5)

close_port = tk.Button(master_window, text="Close Port", command=lambda: close_func())
close_port.grid(row=7, column=0, padx=5, pady=5)


master_window.mainloop()
