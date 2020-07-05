#include <stdlib.h>
#include <plog/Log.h> /* this for all the code that needs the PLOG_* stuff */
#include <plog/Init.h> /* this only for the initialization */
#include <plog/Formatters/TxtFormatter.h>
#include <plog/Appenders/ColorConsoleAppender.h>

#include "Vuart_tx.h"
#include "verilated_vcd_c.h"
#include "verilated.h"

uint64_t tickcount = 0;

typedef enum {
    IDLE,
    TRANSMITTING
} tx_state_t;

size_t tx_counter = 0;

tx_state_t tx_state = IDLE;
unsigned char tx_data;


void tickPeripherals(Vuart_tx* v) {
    // if in reset state we have nothing to do
    if (!v->reset)
        return;

    switch (tx_state) {
        case IDLE:
            if (!v->o_tx) {
                PLOG_DEBUG << " [+] tx starting communications";
                tx_counter = 0;
                tx_data = 0x00;
                tx_state = TRANSMITTING;
            }
            break;

        case TRANSMITTING:
            if (tx_counter < 8) {
                //PLOG_DEBUG << v->o_tx;
                tx_data = tx_data | v->o_tx << (tx_counter);
                tx_counter++;
            } else {
                std::stringstream ss;
                ss << "transmitted byte: '" << tx_data << "' (" << std::setfill('0') << std::setw(1) << std::hex << static_cast<int>(tx_data) << ")";
                PLOG_DEBUG << ss.str();
                tx_state = IDLE;
                tx_counter = 0;
            }
            break;
    }
}


void tick(uint64_t tickcount, Vuart_tx* v, VerilatedVcdC* tfp) {
    v->eval();
    if (tfp)
        tfp->dump(tickcount*10 - 2);
    v->clk = 1;
    v->eval();
    if (tfp)
        tfp->dump(tickcount*10);
    v->clk = 0;
    v->eval();
    if (tfp) {
        tfp->dump(tickcount*10 + 5);
        tfp->flush();
    }

    tickPeripherals(v);
}


void transmit(Vuart_tx *tx, uint8_t data, VerilatedVcdC* trace) {
    tx->i_start = 1;
    tx->i_data = data;

    tick(++tickcount, tx, trace);

    tx->i_start = 0;

    assert(tx->o_done == 0);

    for (unsigned int count = 0; count < 20 ; count++) {
        tick(++tickcount, tx, trace);
    }

    assert(tx->o_done == 1);
}

int main(int argc, char* argv[]) {
        // Initialize Verilators variables
    Verilated::commandArgs(argc, argv);

    Verilated::traceEverOn(true);
    VerilatedVcdC* trace = new VerilatedVcdC;

    Vuart_tx* tx = new Vuart_tx;

    static plog::ColorConsoleAppender<plog::TxtFormatter> consoleAppender(plog::streamStdErr);
    plog::init(plog::verbose, &consoleAppender);

    PLOG_INFO << " [+] start tracing";
    tx->trace(trace, 99);
    trace->open("uart_tx.vcd");

    tx->reset = 0;

    // Tick the clock until we are done
    for (unsigned int count = 0; count < 5 ; count++) {
        tick(++tickcount, tx, trace);
    }

    tx->reset = 1;

    transmit(tx, 0xaa, trace);
    transmit(tx, 0x55, trace);
    transmit(tx, 'h', trace);
    transmit(tx, 0x01, trace);

    return EXIT_SUCCESS;
}
