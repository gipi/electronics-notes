#include <stdlib.h>
#include "Vring_counter.h"
#include "verilated_vcd_c.h"
#include "verilated.h"


void tick(uint64_t tickcount, Vring_counter* v, VerilatedVcdC* tfp) {
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

int main(int argc, char **argv) {
    uint64_t tickcount = 0;
	// Initialize Verilators variables
	Verilated::commandArgs(argc, argv);

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

	// Create an instance of our module under test
	Vring_counter *tb = new Vring_counter;
    tb->rst = 1;

    tb->trace(tfp, 99);
    tfp->open("ring_counter_trace.vcd");

	// Tick the clock until we are done
	for (unsigned int count = 0; count < 100 ; count++) {
        tick(++tickcount, tb, tfp);
	}

    exit(EXIT_SUCCESS);
}
