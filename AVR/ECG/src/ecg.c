#include <avr/io.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "m_general.h"
#include "m_usb.h"

// static int usart_putchar(char c, FILE *stream);
// static FILE mystdout = FDEV_SETUP_STREAM(usart_putchar, NULL, _FDEV_SETUP_WRITE);
#if 0
void init_timer() {
    TCCR0B |= _BV(CS00) | _BV(CS02); // clk/1024
    TIMSK0 |= _BV(TOIE0);            // enable Timer0 Overflow Interrupt
}

ISR(TIMER0_OVF_vect) {
    // do stuffs
    printf("A");
}
#endif

void led_init() {
  DDRC |= (1 << DDC7);
}

void led_cycle() {
    // LED Animation
    PORTC |= (1 << DDC7);
    _delay_ms(500);
    PORTC &= ~(1 << DDC7);
    _delay_ms(500);
}

void led_signal() {
    for (int cycle = 0 ; cycle < 3 ; cycle++) {
        led_cycle();
    }
}

int main() {
    // usart_init();
    //init_timer();
    // sei(); // needed in order to enable interrupts
    led_init();

    m_usb_init();

    while(!m_usb_isconnected()); // wait for a connection


    while(1) // needed in order to don't crash the code (?)
        m_usb_tx_string("ciao\n");

    return 0;
}

