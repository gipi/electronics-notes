/*
 * Assembler for our personal ISA.
 *
 * TODO: add Line class that represents each line
 *
 * Example for source code:
 *
 *    ld r1, 0xabad
 *    ldu r1, 0x1dea
 *    ld r10, $whatever
 *    jrl r10
 *    hl
 *   .whatever:
 *    mov r5, r1
 *    jr r15
 *
 *  We have decoding from source code to an abstract representation of it by line
 *  and by relations between variables.
 */
#include <iostream>
#include <fstream>
#include <plog/Log.h>
#include <plog/Init.h>
#include <plog/Formatters/TxtFormatter.h>
#include <plog/Appenders/ColorConsoleAppender.h>
#include "source.h"

void usage(char* progname) {
    std::cout << "usage: " << progname << " <source file>" << std::endl;
    exit(1);
}


int main(int argc, char* argv[]) {
    if (argc < 2) {
        usage(argv[0]);
    }

    static plog::ColorConsoleAppender<plog::TxtFormatter> consoleAppender(plog::streamStdErr);
    plog::init(plog::verbose, &consoleAppender);

    PLOG_INFO << "reading source file '" << argv[1] << "'";
    std::ifstream stream(argv[1], std::ios::in);
    Source source(stream, 0xb0000000);

    PLOG_INFO << "encoding source";
    std::cout << source.encode();
}
