/*
 * SPI Master.
 *
 * Code directly inspired from the datasheet of the ATMega32u4.
 *
 * TODO: adapt code for other models.
 *
 * In this example we have two shift registers daisy-chained and we transmit two
 * bytes to receive the content of them. The SS pin is configured as output and
 * connected to the SH/~LD pin of both shift registers; in this way, when we
 * raise the SS pin we capture the last parallel input as seen by them.
 */

#include <avr/io.h>
#include <util/delay.h>
#include <uart.h>

#define BLINKING_TIME 100

#define DDR_SPI DDRB
#define DD_MOSI PB2
#define DD_MISO PB3
#define DD_SCK  PB1
#define DD_SS   PB0

void SPI_master_init() {
    /* Set MOSI, SS and SCK output, all others input */
    DDR_SPI = (1 << DD_MOSI) | (1 << DD_SCK) | (1 << DD_SS);
    /* Enable SPI, Master, set clock rate fck/16 */
    SPCR = (1 << SPE) | (1 << MSTR) | (1 << SPR0);
}


/* while we transmit we also receive */
uint8_t SPI_masterTransmit(char cData)
{
    /* Start transmission */
    SPDR = cData;
    /* Wait for transmission complete */
    while(!(SPSR & (1 << SPIF)))
        ;

    return SPDR;
}

#define pin_output(x,y) DDR##x |= _BV(P##x##y);
#define pin_high(x,y) PORT##x |= _BV(P##x##y)
#define pin_low(x,y) PORT##x &= ~_BV(P##x##y)

#define SS_high() pin_high(B,0)
#define SS_low() pin_low(B,0)


void blink() {
    pin_output(D, 5)
    pin_high(D, 5);

    for (unsigned int cycle = 0 ; cycle < 5 ; cycle++) {
        _delay_ms(BLINKING_TIME);     //Wait X milliseconds
        pin_low(D, 5); //Turn LED off

        _delay_ms(BLINKING_TIME);     //Wait X milliseconds
        pin_high(D, 5);  //Turn LED on
    }
}


int main(void) {
    /* setup uart */
    uart_init();
    /* setup SPI */
    SPI_master_init();

    /* SS is connected to the SH/~LD pin of the shift register */
    SS_low();

    uart_puts_p(PSTR("SPI demo\n"));
    blink();

    char miao[64];


    /* now we raise the SH pin and activate the transmission mode */
    SS_high();

    uint8_t c0 = SPI_masterTransmit(0xa5);
    uint8_t c1 = SPI_masterTransmit(0xa5);

    sprintf(miao, "%04x\n", c0 | (c1 << 8));

    uart_puts(miao);

    return 0;
}
