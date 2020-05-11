#include <stdlib.h>
#include "Vhvsync_generator.h"
#include "verilated.h"

#define LOG(...) fprintf(stderr, __VA_ARGS__)


int main(int argc, char *argv[]) {
    LOG(" [+] starting VGA simulation\n");
    uint64_t tickcount = 0;

    Vhvsync_generator* vga = new Vhvsync_generator;

    vga->rst = 0;
    for ( ; tickcount < 100 ; ) {
        if (tickcount > 10) {
            vga->rst = 1;
        }
        vga->clk = 0;
        vga->eval();

        vga->clk = 1;
        vga->eval();

        tickcount++;
    }

    return EXIT_SUCCESS;
}
