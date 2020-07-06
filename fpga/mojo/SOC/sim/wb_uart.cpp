#include <stdlib.h>
#include <plog/Log.h> /* this for all the code that needs the PLOG_* stuff */
#include <plog/Init.h> /* this only for the initialization */
#include <plog/Formatters/TxtFormatter.h>
#include <plog/Appenders/ColorConsoleAppender.h>

#include "Vwb_uart.h"
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


void tickPeripherals(Vwb_uart* v) {
    // if in reset state we have nothing to do
    if (!v->reset)
        return;

    switch (tx_state) {
        case IDLE:
            if (!v->o_uart_tx) {
                PLOG_DEBUG << " [+] tx starting communications";
                tx_counter = 0;
                tx_data = 0x00;
                tx_state = TRANSMITTING;
            }
            break;

        case TRANSMITTING:
            if (tx_counter < 8) {
                //PLOG_DEBUG << v->o_uart_tx;
                tx_data = tx_data | v->o_uart_tx << (tx_counter);
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


void tick(uint64_t tickcount, Vwb_uart* v, VerilatedVcdC* tfp) {
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


void transmit(Vwb_uart *tx, uint8_t data, VerilatedVcdC* trace) {
    /* configure starting handshake */
    tx->i_wb_addr = 0; /* TX_REG */
    tx->i_wb_we = 1;   /* writing */
    tx->i_wb_cyc = 1;  /* start cycle */
    tx->i_wb_stb = 1;  /* start phase */
    tx->i_wb_data = data; /* data to TX */

    tick(++tickcount, tx, trace); /* make the TX latch the data */

    assert(tx->o_wb_ack == 1); /* the slave asserts o_wb_ack in response to i_wb_stb */
    tx->i_wb_stb = 0; /* the master negates i_wb_stb in response to o_wb_ack */

    tick(++tickcount, tx, trace);

    tx->i_wb_cyc = 0;

    for (unsigned int count = 0; count < 20 ; count++) {
        tick(++tickcount, tx, trace);
    }

    assert(tx->o_wb_ack == 0);
}

int main(int argc, char* argv[]) {
        // Initialize Verilators variables
    Verilated::commandArgs(argc, argv);

    Verilated::traceEverOn(true);
    VerilatedVcdC* trace = new VerilatedVcdC;

    Vwb_uart* tx = new Vwb_uart;

    static plog::ColorConsoleAppender<plog::TxtFormatter> consoleAppender(plog::streamStdErr);
    plog::init(plog::verbose, &consoleAppender);

    PLOG_INFO << " [+] start tracing";
    tx->trace(trace, 99);
    trace->open("wb_uart.vcd");

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
