#include <stdlib.h>
#include "Vwb_memory.h"
#include "verilated_vcd_c.h"
#include "verilated.h"


void tick(uint64_t tickcount, Vwb_memory* v, VerilatedVcdC* tfp) {
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
    Vwb_memory *uut = new Vwb_memory;

    uut->trace(tfp, 99);
    tfp->open("wb_memory_trace.vcd");

    // Tick the clock until we are done
    for (unsigned int count = 0; count < 10 ; count++) {
        tick(++tickcount, uut, tfp);
    }

    uut->wb_memory__DOT__ram[0] = 0xabad1d34;

    uut->i_enable = 1;
    uut->i_wb_stb = 1;

    tick(++tickcount, uut, tfp);

    uut->i_wb_stb = 0;
    assert(uut->o_wb_ack == 1);
    uut->i_enable = 0;
    assert(uut->o_data == 0xabad1d34);

    tick(++tickcount, uut, tfp);

    uut->i_enable = 1;
    uut->i_wb_stb = 1;
    uut->i_we = 1;
    uut->i_data = 0xcafebabe;

    tick(++tickcount, uut, tfp);
    uut->i_wb_stb = 0;
    assert(uut->o_wb_ack == 1);
    assert(uut->wb_memory__DOT__ram[0] == 0xcafebabe);

    tick(++tickcount, uut, tfp);

    uut->i_enable = 0;
    uut->i_we = 0;

    tick(++tickcount, uut, tfp);

    uut->i_enable = 1;
    uut->i_wb_stb = 1;

    tick(++tickcount, uut, tfp);

    assert(uut->o_wb_ack == 1);
    assert(uut->o_data == 0xcafebabe);

    uut->i_wb_stb = 0;
    uut->i_enable = 0;

    // Tick the clock until we are done
    for (unsigned int count = 0; count < 10 ; count++) {
        tick(++tickcount, uut, tfp);
    }

    exit(EXIT_SUCCESS);
}
