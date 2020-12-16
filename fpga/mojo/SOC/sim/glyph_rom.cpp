#include <stdlib.h>
#include "Vglyph_rom.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define LOG(...) fprintf(stderr, __VA_ARGS__)


uint8_t tick(Vglyph_rom* rom, VerilatedVcdC* t, uint64_t tickcount) {
        rom->i_wb_stb = 0;
        rom->clk = 0;
        rom->eval();
        t->dump(tickcount*50);

        rom->i_wb_stb = 1;
        rom->clk = 1;
        rom->eval();
        t->dump(tickcount*50 + 10);

        uint8_t value = rom->o_data;

        rom->i_addr = 0x22a1;
        rom->i_wb_stb = 0;
        rom->clk = 0;
        rom->eval();
        t->dump(tickcount*50 + 20);

        rom->i_wb_stb = 0;
        rom->clk = 1;
        rom->eval();
        t->dump(tickcount*50 + 30);

        rom->i_wb_stb = 0;
        rom->clk = 0;
        rom->eval();
        t->dump(tickcount*50 + 40);

    return value;
}

int main(int argc, char *argv[]) {
    LOG(" [+] starting Glyph ROM simulation\n");
    uint64_t tickcount = 0;

    Vglyph_rom* g_rom = new Vglyph_rom;

    Verilated::traceEverOn(true);
    VerilatedVcdC* trace = new VerilatedVcdC;

    g_rom->trace(trace, 99);
    trace->open("glyph_rom.vcd");

    printf("[character code %x]\n", tickcount >> 7);
    for ( ; tickcount < 16834 ; ) {
        g_rom->i_addr = tickcount;
        uint8_t value = tick(g_rom, trace, tickcount);

        if (((tickcount % 8) == 0) && tickcount) {
            printf("\n");
        }

        if ((tickcount % (8 * 16)) == 0 && tickcount) {
            printf("[character code %x]\n", tickcount >> 7);
        }
        printf("%c", value ? '#' : ' ');

        tickcount++;
    }

    return EXIT_SUCCESS;
}
