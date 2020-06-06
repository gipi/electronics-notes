/*
 * Assembler for our personal ISA.
 */
#include <iostream>
#include <fstream>
#include <iomanip>
#include "assembly.h"

void usage(char* progname) {
    std::cout << "usage: " << progname << " <source file>" << std::endl;
    exit(1);
}

enum LineType {
    COMMENT,
    DIRECTIVE,
    CODE,
};


LineType getType(char* line) {
    if (line[0] == '#') {
        return COMMENT;
    } else if (line[0] == '.') {
        return DIRECTIVE;
    }

    return CODE;
}


int main(int argc, char* argv[]) {
    if (argc < 2) {
        usage(argv[0]);
    }

    std::ifstream source(argv[1], std::ios::in);

    while (true) {
        char line[64];

        source.getline(line, 63); /* FIXME: understand how behaves the count argument! */

        if (source.fail()) {
            break;
        }

        switch (getType(line)) {
            case CODE: {
                ISA::Instruction instruction(line);
                std::cout << std::setfill('0') <<  std::setw(8) << std::hex << instruction.getEncoding() << std::endl;
                break;
            }
            case COMMENT:
                std::cerr << "found comment" << std::endl;
                break;
            case DIRECTIVE:
                std::string directive(line);
                std::cerr << "found directive '" << directive << "'" << std::endl;
                if (directive.find(".word") != std::string::npos) {
                    std::cout << directive.substr(6) << std::endl;
                }
                break;
        }
    }

}
