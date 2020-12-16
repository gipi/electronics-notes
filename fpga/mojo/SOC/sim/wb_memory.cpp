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

    // set the memory contents to something known
    uut->wb_memory__DOT__ram[0] = 0x34;
    uut->wb_memory__DOT__ram[1] = 0x1d;
    uut->wb_memory__DOT__ram[2] = 0xad;
    uut->wb_memory__DOT__ram[3] = 0xab;

    // READ
    // 1. read back a word (32bit)
    uut->i_wb_cyc = 1;
    uut->i_wb_stb = 1;
    uut->i_width = 3;

    tick(++tickcount, uut, tfp);

    assert(uut->o_wb_ack == 1); // check we have an ack back
    assert(uut->o_data == 0xabad1d34); // check we have what we expect

    uut->i_wb_stb = 0;
    uut->i_wb_cyc = 0;

    tick(++tickcount, uut, tfp);

    // 2. read a short (16bit)
    uut->i_wb_cyc = 1;
    uut->i_wb_stb = 1;
    uut->i_width = 1;

    tick(++tickcount, uut, tfp);

    assert(uut->o_wb_ack == 1); // check we have an ack back
    assert(uut->o_data == 0x1d34); // check we have what we expect

    uut->i_wb_stb = 0;
    uut->i_wb_cyc = 0;

    tick(++tickcount, uut, tfp);

    // 3. read a byte (8bit)
    uut->i_wb_cyc = 1;
    uut->i_wb_stb = 1;
    uut->i_width = 0;

    tick(++tickcount, uut, tfp);

    assert(uut->o_wb_ack == 1); // check we have an ack back
    assert(uut->o_data == 0x34); // check we have what we expect

    uut->i_wb_stb = 0;
    uut->i_wb_cyc = 0;

    tick(++tickcount, uut, tfp);

    // WRITE
    // 1. write a word (32bit)
    uut->i_wb_cyc = 1;
    uut->i_wb_stb = 1;
    uut->i_we = 1;
    uut->i_width = 3;
    uut->i_data = 0xcafebabe;

    tick(++tickcount, uut, tfp);
    uut->i_wb_stb = 0;
    assert(uut->o_wb_ack == 1);
    assert(uut->wb_memory__DOT__ram[0] == 0xbe);
    assert(uut->wb_memory__DOT__ram[1] == 0xba);
    assert(uut->wb_memory__DOT__ram[2] == 0xfe);
    assert(uut->wb_memory__DOT__ram[3] == 0xca);

    tick(++tickcount, uut, tfp);

    uut->i_wb_cyc = 0;
    uut->i_we = 0;

    tick(++tickcount, uut, tfp);

    uut->i_wb_cyc = 1;
    uut->i_wb_stb = 1;

    tick(++tickcount, uut, tfp);

    assert(uut->o_wb_ack == 1);
    assert(uut->o_data == 0xcafebabe);
    // 2. write a short (16bit)
    uut->i_wb_cyc = 1;
    uut->i_wb_stb = 1;
    uut->i_we = 1;
    uut->i_width = 1;
    uut->i_data = 0x1b4d1d3a;

    tick(++tickcount, uut, tfp);
    uut->i_wb_stb = 0;
    assert(uut->o_wb_ack == 1);
    assert(uut->wb_memory__DOT__ram[0] == 0x3a);
    assert(uut->wb_memory__DOT__ram[1] == 0x1d);
    assert(uut->wb_memory__DOT__ram[2] == 0xfe);
    assert(uut->wb_memory__DOT__ram[3] == 0xca);

    tick(++tickcount, uut, tfp);

    uut->i_wb_cyc = 0;
    uut->i_we = 0;

    tick(++tickcount, uut, tfp);

    uut->i_wb_cyc = 1;
    uut->i_width = 3;
    uut->i_wb_stb = 1;

    tick(++tickcount, uut, tfp);

    assert(uut->o_wb_ack == 1);
    assert(uut->o_data == 0xcafe1d3a);

    uut->i_wb_stb = 0;
    uut->i_wb_cyc = 0;
    // 3. write a byte (8bit)
    uut->i_wb_cyc = 1;
    uut->i_wb_stb = 1;
    uut->i_we = 1;
    uut->i_width = 0;
    uut->i_data = 0x1b4d1dff;

    tick(++tickcount, uut, tfp);
    uut->i_wb_stb = 0;
    assert(uut->o_wb_ack == 1);
    assert(uut->wb_memory__DOT__ram[0] == 0xff);
    assert(uut->wb_memory__DOT__ram[1] == 0x1d);
    assert(uut->wb_memory__DOT__ram[2] == 0xfe);
    assert(uut->wb_memory__DOT__ram[3] == 0xca);

    tick(++tickcount, uut, tfp);

    uut->i_wb_cyc = 0;
    uut->i_we = 0;

    tick(++tickcount, uut, tfp);

    uut->i_wb_cyc = 1;
    uut->i_width = 3;
    uut->i_wb_stb = 1;

    tick(++tickcount, uut, tfp);

    assert(uut->o_wb_ack == 1);
    assert(uut->o_data == 0xcafe1dff);

    uut->i_wb_stb = 0;
    uut->i_wb_cyc = 0;

    // Tick the clock until we are done
    for (unsigned int count = 0; count < 10 ; count++) {
        tick(++tickcount, uut, tfp);
    }

    exit(EXIT_SUCCESS);
}
