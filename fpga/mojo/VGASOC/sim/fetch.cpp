#include <stdlib.h>
#include <vector>
#include <sstream>
#include <stdexcept>
#include "Vfetch.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


#define LOG(...) fprintf(stderr, __VA_ARGS__)

void tick(Vfetch* f, uint64_t tickcount, VerilatedVcdC* tfp) {
    f->eval();
    if (tfp)
        tfp->dump(tickcount*10 - 2);
    f->clk = 1;
    f->eval();
    if (tfp)
        tfp->dump(tickcount*10);
    f->clk = 0;
    f->eval();
    if (tfp) {
        tfp->dump(tickcount*10 + 5);
        tfp->flush();
    }
}

int main(int argc, char* argv[]) {
    LOG(" [+] starting fetch stage simulation\n");
    Verilated::commandArgs(argc, argv);

    Vfetch* fetch = new Vfetch;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    fetch->trace(tfp, 99);
    tfp->open("fetch_trace.vcd");

    uint64_t timetick = 0;

    fetch->reset = 0;
    while(timetick < 10) {
        tick(fetch, ++timetick, tfp);
        assert(fetch->o_completed == 0);
    }

    fetch->reset = 1;

    LOG(" [+] out of reset\n");

    while(timetick < 15) {
        tick(fetch, ++timetick, tfp);
        assert(fetch->o_completed == 0);
    }

    // start a transaction
    fetch->i_enable = 1;
    fetch->i_pc = 0xcafebabe;

    tick(fetch, ++timetick, tfp);

    assert(fetch->o_wb_cyc == 1);
    assert(fetch->o_wb_stb == 1);

    tick(fetch, ++timetick, tfp);

    assert(fetch->o_wb_cyc == 1);
    assert(fetch->o_wb_stb == 0);

    tick(fetch, ++timetick, tfp);

    fetch->i_wb_ack = 1;
    fetch->i_wb_data = 0xabad1dea;

    tick(fetch, ++timetick, tfp);

    assert(fetch->o_wb_cyc == 0);
    assert(fetch->o_completed == 1);
    assert(fetch->o_instruction == 0xabad1dea);

    fetch->i_wb_ack = 0;
    tick(fetch, ++timetick, tfp);

    assert(fetch->o_completed == 0);

    return EXIT_SUCCESS;
}
