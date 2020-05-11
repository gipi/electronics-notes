#include <stdlib.h>
#include "Vglyph_rom.h"
#include "verilated.h"

#define LOG(...) fprintf(stderr, __VA_ARGS__)


int main(int argc, char *argv[]) {
    LOG(" [+] starting Glyph ROM simulation\n");
    uint64_t tickcount = 0;

    Vglyph_rom* g_rom = new Vglyph_rom;

    printf("[character code %x]\n", tickcount >> 7);
    for ( ; tickcount < 16834 ; ) {
        g_rom->addr = tickcount;
        // printf(" [character code %x]", tickcount);
        g_rom->clk = 0;
        g_rom->eval();

        g_rom->clk = 1;
        g_rom->eval();

        if (((tickcount % 8) == 0) && tickcount) {
            printf("\n");
        }

        if ((tickcount % (8 * 16)) == 0 && tickcount) {
            printf("[character code %x]\n", tickcount >> 7);
        }
        printf("%c", g_rom->data ? '#' : ' ');


        g_rom->clk = 0;
        g_rom->eval();

        tickcount++;
    }

    return EXIT_SUCCESS;
}
