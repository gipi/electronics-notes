/*
Copyright 2010 Volts and Bytes
http://voltsandbytes.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#define F_CPU 	8000000UL
#define FOSC 	8000000 // Clock Speed
#define BAUD 	9600
#define MYUBRR	FOSC/16/BAUD-1
#define STX		0x02
#define ACK		0x06
#define NAK		0x15
#define SIZE	69

#include<avr/io.h>
#include<util/delay.h>

void init_all(void);
void USART_Init(unsigned int);
void USART_Transmit(unsigned char);
unsigned char USART_Receive(void);
void EEPROM_write(unsigned int, unsigned char);
unsigned char EEPROM_read(unsigned int);

unsigned char buffer[SIZE+1];

int main(void) {	
	unsigned char ctr=0;
	unsigned char checker=0;
	unsigned char temp;

	init_all();

	_delay_ms(10);

	while(1)
	{	
		if((PIND & 0x20) == 0x20)
		{
			for(ctr=0;ctr<SIZE;ctr++)		
				{
					temp=EEPROM_read(ctr);			//display EEPROM data
					PORTB=~temp;
					_delay_ms(10);
				}
			PORTB=0xFF;
		}
		else
		{
			PORTB=0xFF;

			while(USART_Receive()!=STX);			//wait for start byte

			USART_Transmit(ACK);					//send ack byte when start byte is received

			for(ctr=0;ctr<SIZE+1;ctr++)
			{
				buffer[ctr]=USART_Receive();		//fill buffer
				checker+=buffer[ctr];				//find sum of buffer
			}

			if(checker==0xFF)
			{
				for(ctr=0;ctr<SIZE;ctr++)		
				{
					EEPROM_write(ctr, buffer[ctr]);	//write buffer contents to EEPROM minus the checksum byte
				}
				USART_Transmit(ACK);				//send ack byte
			}
			else
			{
				USART_Transmit(NAK);				//send no ack byte
			}
		}
	}
}

void init_all(void) {
	//initialize pins
	DDRB = 0xFF;

	PORTB=0xFF;
	PORTD=0xDF; 

	USART_Init(MYUBRR);
}

// pg 183 from datasheet of atmega328
void USART_Init(unsigned int ubrr) {
	/* Set baud rate */
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;
	/* Enable receiver and transmitter */
	UCSR0B = (1<<RXEN0)|(1<<TXEN0);
	/* Set frame format: 8data, 1stop bit */
	UCSR0C = (3<<UCSZ00);
}

void USART_Transmit(unsigned char data) {
	/* Wait for empty transmit buffer */
	while ( !( UCSRA & (1<<UDRE)) )
	;
	/* Put data into buffer, sends the data */
	UDR = data;
}

unsigned char USART_Receive(void) {
	/* Wait for data to be received */
	while ( !(UCSRA & (1<<RXC)) )
	;
	/* Get and return received data from buffer */
	return UDR;
}

void EEPROM_write(unsigned int uiAddress, unsigned char ucData) {
	/* Wait for completion of previous write */
	while(EECR & (1<<EEPE))
	;
	/* Set up address and data registers */
	EEAR = uiAddress;
	EEDR = ucData;
	/* Write logical one to EEMPE */
	EECR |= (1<<EEMPE);
	/* Start eeprom write by setting EEPE */
	EECR |= (1<<EEPE);
}

unsigned char EEPROM_read(unsigned int uiAddress) {
	/* Wait for completion of previous write */
	while(EECR & (1<<EEPE))
	;
	/* Set up address register */
	EEAR = uiAddress;
	/* Start eeprom read by writing EERE */
	EECR |= (1<<EERE);
	/* Return data from data register */
	return EEDR;
}
