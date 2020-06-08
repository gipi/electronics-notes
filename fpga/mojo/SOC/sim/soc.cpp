#include <stdlib.h>
#include <vector>
#include <sstream>
#include <stdexcept>
#include "Vsoc.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


#define LOG(...) fprintf(stderr, __VA_ARGS__)

#if 0
#define LOGSOC(c) LOG("state: %s\ti_data: %08x instruction: %08x opcode: %02x next_state: %02x\n",\
    STATES[(c)->soc__DOT__core__DOT__current_state], \
    (c)->soc__DOT__cpu_to_rom_signal_data,           \
    (c)->soc__DOT__core__DOT__q_instruction,         \
    (c)->soc__DOT__core__DOT__q_opcode,              \
    (c)->soc__DOT__core__DOT__next_state)
#else
#define LOGSOC(c) 
#endif

void tick(Vsoc* s, uint64_t tickcount, VerilatedVcdC* tfp) {
    s->eval();
    if (tfp)
        tfp->dump(tickcount*10 - 2);
    s->clk = 1;
    s->eval();
    if (tfp)
        tfp->dump(tickcount*10);
    s->clk = 0;
    s->eval();
    if (tfp) {
        tfp->dump(tickcount*10 + 5);
        tfp->flush();
    }
}

int main(int argc, char* argv[]) {
    LOG(" [+] starting CPU simulation\n");
    Verilated::commandArgs(argc, argv);

    Vsoc* soc = new Vsoc;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    soc->trace(tfp, 99);
    tfp->open("soc_trace.vcd");

    uint64_t timetick = 0;

    soc->reset = 0;
    while(timetick < 10) {
        tick(soc, ++timetick, tfp);
    }

    soc->reset = 1;

    LOG(" [+] out of reset\n");

    while(timetick < 150) {
        tick(soc, ++timetick, tfp);

        LOGSOC(soc);
    }

    return EXIT_SUCCESS;
}
