#!/usr/bin/env python3
"""
Script to use with the output of KeyboardMatrixRecovery.ino to generate
the header for the layout to import into ATMega32u4-HID-Keyboard.
"""
inputs = {0, 1, 2, 4, 5, 7, 8, 11}
outputs = {3, 6, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23}


keys = [(0, 10), (11, 12),(8, 12), (7, 12), (0, 12), (8, 9), (7, 9), (0, 9), (9, 11), (8, 21), (7, 21), (0, 21), (11, 21),
    (0, 16), (11, 20), (0, 23), (11, 23), (8, 10), (2, 10), (2, 9), (2, 12), (2, 13), (8, 13), (8, 15), (2, 15), (2, 16),
    (2, 21), (2, 22), (8, 22), (11, 22), (0, 20), (7, 23), (7, 10), (1, 10), (1, 9), (1, 12), (1, 13), (7, 13), (7, 15),
    (1, 15), (1, 16), (1, 21), (1, 22), (7, 22), (7, 16), (4, 20), (8, 23), (10, 11), (4, 10), (4, 9), (4, 12), (4, 13),
    (0, 13), (0, 15), (4, 15), (4, 16), (4, 21), (4, 22), (0, 22), (8, 20), (4, 23), (3, 5), (8, 16), (5, 10), (5, 9),
    (5, 12), (5, 13), (11, 13), (11, 15), (5, 15), (5, 16), (5, 21), (5, 22), (1, 3), (1, 20), (5, 23), (6, 7), (8, 14),
    (0, 17), (2, 19), (5, 20), (11, 19), (8, 18), (4, 6), (1, 23), (2, 20), (2, 23)
]

layout = [
    ['KEY_ESC', 'KEY_F1', 'KEY_F2', 'KEY_F3', 'KEY_F4', 'KEY_F5', 'KEY_F6', 'KEY_F7', 'KEY_F8', 'KEY_F9', 'KEY_F10', 'KEY_F11', 'KEY_F12', 'KEY_SCROLLLOCK', 'KEY_PAUSE', 'KEY_INSERT', 'KEY_DELETE'],
    ['KEY_BACKSLASH', 'KEY_1', 'KEY_2', 'KEY_3', 'KEY_4', 'KEY_5', 'KEY_6', 'KEY_7', 'KEY_8', 'KEY_9', 'KEY_0', 'KEY_APOSTROPHE', 'KEY_IT_IGRAVE', 'KEY_BACKSPACE', 'KEY_HOME'],
    ['KEY_TAB', 'KEY_Q', 'KEY_W', 'KEY_E', 'KEY_R', 'KEY_T', 'KEY_Y', 'KEY_U', 'KEY_I', 'KEY_O', 'KEY_P', 'KEY_IT_EGRAVE', 'KEY_IT_PLUS', 'KEY_ENTER', 'KEY_PAGEUP'],
    ['KEY_CAPSLOCK', 'KEY_A', 'KEY_S', 'KEY_D', 'KEY_F', 'KEY_G', 'KEY_H', 'KEY_J', 'KEY_K', 'KEY_L', 'KEY_IT_OGRAVE', 'KEY_IT_AGRAVE', 'KEY_IT_UGRAVE', 'KEY_PAGEDOWN'],
    ['KEY_MOD_LSHIFT', 'KEY_IT_TRIANGLE', 'KEY_Z', 'KEY_X', 'KEY_C', 'KEY_V', 'KEY_B', 'KEY_N', 'KEY_M', 'KEY_COMMA', 'KEY_DOT', 'KEY_MINUS', 'KEY_MOD_RSHIFT', 'KEY_UP', 'KEY_END'],
    ['KEY_MOD_LCTRL', 'KEY_MOD_LMETA', 'KEY_MOD_WINDOWS', 'KEY_MOD_LALT', 'KEY_SPACEBAR', 'KEY_MOD_RALT', 'KEY_BOH', 'KEY_MOD_RCTRL', 'KEY_LEFT', 'KEY_DOWN', 'KEY_RIGHT']
]

def generate_layout(k, l):
    result = []
    ikeys = iter(k)
    for row in l:
        result.append([(code, next(ikeys)) for code in row])

    return result

def generate_matrix(inputs, outputs, k, l):
    tmp = generate_layout(k, l)

    matrix = [['0' for _ in outputs] for _ in inputs]

    inputs = list(inputs)
    outputs = list(outputs)

    for row in tmp:
        for element in row:
            key, (a, b) = element
            (i, o) = (a, b) if a in inputs else (b, a)
            matrix[inputs.index(i)][outputs.index(o)] = key

    return matrix

def generate_header(inputs, outputs, k, l):
    matrix = generate_matrix(inputs, outputs, k, l)

    print("/* {} */".format(', '.join(["{:>16}".format(_) for _ in outputs])))

    print("layout = {")

    inputs = list(inputs)
    outputs = list(outputs)

    for row, i in zip(matrix, inputs):
        print("/* {:>2} */ {{".format(i),end='')
        print(', '.join(["{:>16}".format(_) for _ in row]), end='')
        print("},")

if __name__ == '__main__':
    generate_header(inputs, outputs, keys, layout)
