#include <stdlib.h>
#include "Vuart_tx.h"
#include "verilated_vcd_c.h"
#include "verilated.h"


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
}

int main(int argc, char* argv[]) {
        // Initialize Verilators variables
    Verilated::commandArgs(argc, argv);

    Verilated::traceEverOn(true);
    VerilatedVcdC* trace = new VerilatedVcdC;

    Vuart_tx* tx = new Vuart_tx;

    tx->trace(trace, 99);
    trace->open("uart_tx.vcd");

    uint64_t tickcount = 0;
    tx->reset = 0;

    // Tick the clock until we are done
    for (unsigned int count = 0; count < 5 ; count++) {
        tick(++tickcount, tx, trace);
    }

    tx->reset = 1;

    tx->i_start = 1;
    tx->i_data = 0x55;

    tick(++tickcount, tx, trace);

    tx->i_start = 0;

    for (unsigned int count = 0; count < 15 ; count++) {
        tick(++tickcount, tx, trace);
    }


    return EXIT_SUCCESS;
}
