#include <stdlib.h>
#include "Vtext_ram.h"
#include "verilated.h"

#define LOG(...) fprintf(stderr, __VA_ARGS__)

void dump(Vtext_ram* ram) {
    printf("--------------------------------------------------------------------------------.\n");
    uint64_t tickcount = 0;
    for ( ; tickcount < 80*30 ; ) {
        ram->addr = tickcount;
        ram->clk = 0;
        ram->eval();

        ram->clk = 1;
        ram->eval();

        if ((tickcount % (80)) == 0 && tickcount) {
            printf("|\n");
        }
        uint8_t value = ram->o_data;

        printf("%c", isprint(value) ? value : '.');

        ram->clk = 0;
        ram->eval();

        tickcount++;
    }
    printf("|\n\n");
}

void write_at(Vtext_ram* ram, uint8_t col, uint8_t row, uint8_t value) {
    unsigned short addr = col + (row * 80);
    ram->addr = addr;
    ram->we = 1;
    ram->i_data = value;
    ram->clk = 0;
    ram->eval();

    ram->clk = 1;
    ram->eval();

    ram->we = 0;
    ram->clk = 0;
    ram->eval();
}

int main(int argc, char *argv[]) {
    LOG(" [+] starting TEXT RAM simulation\n");

    Vtext_ram* t_ram = new Vtext_ram;

    dump(t_ram);

    write_at(t_ram, 0, 0, 'X');
    write_at(t_ram, 1, 0, 'X');
    write_at(t_ram, 1, 2, 'X');

    write_at(t_ram, 0, 0, 'H');
    write_at(t_ram, 1, 0, 'e');
    write_at(t_ram, 2, 0, 'l');
    write_at(t_ram, 3, 0, 'l');
    write_at(t_ram, 4, 0, 'o');

    write_at(t_ram, 0, 1, 'H');
    write_at(t_ram, 1, 1, 'e');
    write_at(t_ram, 2, 1, 'l');
    write_at(t_ram, 3, 1, 'l');
    write_at(t_ram, 4, 1, 'o');

    write_at(t_ram, 0, 1, 'X');
    write_at(t_ram, 1, 1, 'X');
    write_at(t_ram, 1, 1, 'X');

    dump(t_ram);

    return EXIT_SUCCESS;
}
