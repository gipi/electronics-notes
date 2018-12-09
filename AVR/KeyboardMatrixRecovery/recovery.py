#!/usr/bin/env python3
import sys
import serial
import struct
import logging
import json


logging.basicConfig()
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


READ_KEY_LENGTH = 5

keys = [
    "Esc", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "Bloc. Scorr", "Pausa", "Ins", "Canc",
    "\\", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", "ì"                  , "Backspace"     , "Home",
    "TAB", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "è", "+"                 , "Return"        , "Pag. Up",
    "Caps", "a", "s", "d", "f", "g", "h", "j", "k", "l", "ò", "à", "ù"                                  , "Pag. Down",
    "Left Shift", "<", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "Right Shift",       "Up Arrow", "End",
    "Left Ctrl", "Fn", "Windows", "Left Alt", "Spacebar", "Right Alt", "Menu", "Right Ctrl", "Left Arrow", "Down Arrow", "Right Arrow",
]

def usage(progname):
    print("usage: %s <serial device>" % progname)
    sys.exit(1)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        usage(sys.argv[0])

    path_serial = sys.argv[1]

    serial_keyboard = serial.Serial(path_serial, 115200, timeout=10)

    banner = serial_keyboard.readline()

    logger.debug("banner?: '%s'" % banner)

    if banner != b" --[Start keyboard matrix recovery ]--\r\n":
        raise ValueError("No banner no party")

    matrix = {}

    has_finished = False
    iter_key = iter(keys)
    for key in keys:
        print("Please press key '%s' (10 seconds timeout)" % key)
        data = serial_keyboard.read(READ_KEY_LENGTH)

        logger.debug('> %s' % data)

        signals = (struct.unpack('B', data[3:4])[0], struct.unpack('B', data[4:5])[0]) if len(data) == READ_KEY_LENGTH else None

        logger.debug('signals %s for key %s' % (signals, key))
        matrix[key] = signals

    with open('matrix.json', 'w') as json_file:
        json_file.write(json.dumps(matrix))

    logger.info("matrix output in 'matrix.json'")
