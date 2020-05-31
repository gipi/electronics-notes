/*
 * Assembler for our personal ISA.
 */
#include <iostream>
#include <fstream>
#include "assembly.h"

void usage(char* progname) {
    std::cout << "usage: " << progname << " <source file>" << std::endl;
    exit(1);
}


int main(int argc, char* argv[]) {
    if (argc < 2) {
        usage(argv[0]);
    }

    std::ifstream source(argv[1], std::ios::in);

    while (true) {
        char line[21];

        source.getline(line, 20);

        if (source.fail()) {
            break;
        }

        ISA::Instruction instruction(line);

        std::cout << std::hex << instruction.getEncoding() << std::endl;
    }

}
