/*
 * Simple DIY ECG
 *
 */
#include <avr/io.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "m_general.h"
#include "m_usb.h"

/*
 * The AD8232 has the following connections with the ATMega32U4
 *
 *  LO- -> PD6
 *  LO+ -> PB7
 *  OUTPUT -> PF7 (ADC mode)
 */
void ecg_init() {
    // set pins as input
    DDRD &= ~_BV(PD6);
    DDRB &= ~_BV(PB7);
}

// static int usart_putchar(char c, FILE *stream);
// static FILE mystdout = FDEV_SETUP_STREAM(usart_putchar, NULL, _FDEV_SETUP_WRITE);
void init_timer() {
    TCCR0B |= _BV(CS00); // clk/1
    TIMSK0 |= _BV(TOIE0);            // enable Timer0 Overflow Interrupt
}

volatile uint32_t timestamp = 0;

ISR(TIMER0_OVF_vect) {
    timestamp++;
}

void led_init() {
  // set as an output
  DDRC |= (1 << PC7);
}

void led_cycle() {
    // LED Animation
    PORTC |= (1 << PC7);
    _delay_ms(500);
    PORTC &= ~(1 << PC7);
    _delay_ms(500);
}

void led_signal() {
    for (int cycle = 0 ; cycle < 3 ; cycle++) {
        led_cycle();
    }
}

void adc_init() {
    // AREF = AVcc
    ADMUX = (1 << REFS0);
 
    // ADC Enable and prescaler of 128
    // 16000000/128 = 125000
    ADCSRA = (1 << ADEN) | (1 << ADPS2) |(1 << ADPS1) | (1 << ADPS0);
}

uint16_t adc_read(uint8_t ch) {
  // select the corresponding channel 0~7
  // ANDing with ’7′ will always keep the value
  // of ‘ch’ between 0 and 7
  ch &= 0b00000111;  // AND operation with 7
  ADMUX = (ADMUX & 0xF8) | ch; // clears the bottom 3 bits before ORing
 
  // start single convertion
  // write ’1′ to ADSC
  ADCSRA |= (1 << ADSC);
 
  // wait for conversion to complete
  // ADSC becomes ’0′ again
  // till then, run loop continuously
  while(ADCSRA & (1 << ADSC));
 
  return (ADC);
}


void usb_detach() {
    // detach USB (strangely enough, with the atmega32u4 keyboard this is not needed)
    UDCON |= (1 << DETACH);
    _delay_ms(100);
    UDCON &= ~(1 << DETACH);
}

int main() {
    init_timer();
    ecg_init();
    adc_init();
    led_init();
    m_usb_init();

    usb_detach();

    while(!m_usb_isconnected()); // wait for a connection

    led_signal();
    m_usb_tx_string("HELLO\n");

    while(1) {
        // we want to read from the ADC only if the leads are not detached
        uint16_t value = (bit_is_clear(PORTD, PD6) && bit_is_clear(PORTB, PB7)) ? adc_read(7) : 0;
        m_usb_tx_ulong(timestamp);
        m_usb_tx_string(" ");
        m_usb_tx_uint(value);
        m_usb_tx_string("\n");
    }

    return 0;
}

