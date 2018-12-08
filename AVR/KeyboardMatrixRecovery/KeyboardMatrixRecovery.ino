/*
 * KEYBOARD MATRIX RECOVERY
 * ------------------------
 *
 * Press a key in you keyboard and see which connections are activated.
 *
 * Since we cannot read reliably without using pull up we need
 * to set one pin to output LOW and the other to input with a
 * pull up enabled. In this way when the key is pressed the input
 * should read low. 
 *
 * Originally designed for the Arduino Mega.
 * 
 */

#define N_PINS(_p) (sizeof(_p)/sizeof(_p[0]))
/*
 * The connector I'm using has 30 pins, modify as needed.
 */
unsigned int pins[] {
  22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
  32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
  42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
};


struct _signals {
  unsigned int lines[2];
  bool was_activated;
  bool activated;
} signals;


/*
 * Here we setup only the serial.
 */
void setup() {
  Serial.begin(115200);
  Serial.println(" --[Start keyboard matrix recovery ]--");
}


void set_input(unsigned int pinInputIndex)  {
  pinMode(pins[pinInputIndex], OUTPUT);
  digitalWrite(pins[pinInputIndex], LOW);
}

void set_outputs(unsigned int pinInputIndex) {
  unsigned int cycle;
  for (cycle = 0 ; cycle < N_PINS(pins) ; cycle++) {
    if (cycle == pinInputIndex) {
      continue;
    }
    // here we need the pullup otherwise the reading will be floating
    pinMode(pins[cycle], INPUT_PULLUP);
  }
}

void look_for_signal(unsigned int inputPinIndex) {
  unsigned int cycle;
  for (cycle = inputPinIndex + 1 ; cycle < N_PINS(pins) ; cycle++) {

    unsigned value = digitalRead(pins[cycle]);
    if (value == LOW) {// since we are using pull ups from the input side we need to look for LOW level
      signals.lines[0]= inputPinIndex;
      signals.lines[1] = cycle;
      signals.activated = true;
    }
  }
}


void try_combination(unsigned int inputPinIndex) {
  set_input(inputPinIndex);
  set_outputs(inputPinIndex);

  look_for_signal(inputPinIndex);  
}

/*
 * We simply communicate the key pressed using a raw packet
 * having the format
 * 
 *    [KEY][unsigned int][unsigned int]
 */
void communicate_signal() {
  // output a key only if the signal is activated now but not the previous time
  if (!(signals.activated && !signals.was_activated))
    return;
  Serial.print("KEY");
  Serial.write(signals.lines[0]);
  Serial.write(signals.lines[1]);
}

/*
 * Here we are looping over all the combination of input/output pairs to
 * find possibly connections.
 */
void loop() {
  signals.activated = false;
  unsigned int inputPinIndex;
  for (inputPinIndex = 0 ; inputPinIndex < N_PINS(pins) ; inputPinIndex++) {
    try_combination(inputPinIndex);
  }

  communicate_signal();

  signals.was_activated = signals.activated;
}
