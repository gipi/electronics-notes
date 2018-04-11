/*
 * A simple sketch that blinks a led on pin A5 (port PC5)
 */
#include <avr/io.h>
#include <util/delay.h>

int main() {
    DDRC  = (1 << PC5);       //Sets the direction of the PC7 to output

    PORTC |= (1 << PC5);       //Sets PC7 high
    _delay_ms(5000);
    PORTC &= ~(1 << PC5);       //Sets PC7 low
    _delay_ms(1000);

    while (1) {
        PORTC |= (1 << PC5);
        PORTC &= ~(1 << PC5);
    }

}
