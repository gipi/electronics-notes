#include <util/delay.h>

void setup() {
    //Serial.begin(9600);

    pinMode(A5, OUTPUT);
    digitalWrite(A5, HIGH);
    _delay_ms(100);
    digitalWrite(A5, LOW);
    _delay_ms(100);
    digitalWrite(A5, HIGH);
    _delay_ms(100);
    digitalWrite(A5, LOW);

    //Serial.println("Plis visit our country!!1!");
    //Serial.println("voulez vous inserire le PIN?");
}

void loop() {
    digitalWrite(A5, HIGH);
    _delay_ms(1000);
    digitalWrite(A5, LOW);
    _delay_ms(1000);
}
