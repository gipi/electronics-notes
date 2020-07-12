#include <stdlib.h>
#include <plog/Log.h> /* this for all the code that needs the PLOG_* stuff */
#include <plog/Init.h> /* this only for the initialization */
#include <plog/Formatters/TxtFormatter.h>
#include <plog/Appenders/ColorConsoleAppender.h>

#include "Vwb_uart.h"
#include "verilated_vcd_c.h"
#include "verilated.h"
#define _UART_ 1
#define _WISHBONE_
#include "peripherals.h"


int main(int argc, char* argv[]) {
        // Initialize Verilators variables
    Verilated::commandArgs(argc, argv);

    Verilated::traceEverOn(true);

    static plog::ColorConsoleAppender<plog::TxtFormatter> consoleAppender(plog::streamStdErr);
    plog::init(plog::verbose, &consoleAppender);

    SysCon<Vwb_uart> tx("wb_uart.vcd");

    tx.device->reset = 0;

    // Tick the clock until we are done
    for (unsigned int count = 0; count < 5 ; count++) {
        tx.tick();
    }

    tx.device->reset = 1;

    tx.transmit((uint8_t)0xaa);
    tx.transmit(0x55);
    tx.transmit('h');
    tx.transmit(0x01);

    return EXIT_SUCCESS;
}
