#include <Servo.h>

int potpin = A0;
int val;
Servo motor_1;

void setup() {
  motor_1.attach(9);
  Serial.begin(9600);
  delay(10000);
}

void loop() {
  val = analogRead(potpin);            
  val = map(val, 0, 1023, 0, 180);
  motor_1.write(val);                  
}
