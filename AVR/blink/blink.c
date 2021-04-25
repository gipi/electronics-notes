#include <avr/io.h>
#include <util/delay.h>



int main(void) {
    DDRB  = _BV(PB5);       //Sets the direction of the PC7 to output
    PORTB = _BV(PB5);       //Sets PC7 high

    while(1) {
        _delay_ms(500);     //Wait 500 milliseconds
        PORTB &= ~_BV(PB5); //Turn LED off

        _delay_ms(500);     //Wait 500 milliseconds
        PORTB |= _BV(PB5);  //Turn LED on
    }

    return 0;
}
