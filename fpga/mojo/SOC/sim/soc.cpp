#include <stdlib.h>
#include <vector>
#include <sstream>
#include <stdexcept>
#include <plog/Log.h>
#include <plog/Init.h>
#include <plog/Formatters/TxtFormatter.h>
#include <plog/Appenders/ColorConsoleAppender.h>
#include "Vsoc.h"
#define _WISHBONE_
#define _UART_
#include "peripherals.h"


int main(int argc, char* argv[]) {
    static plog::ColorConsoleAppender<plog::TxtFormatter> consoleAppender(plog::streamStdErr);
    plog::init(plog::verbose, &consoleAppender);

    PLOG_INFO << " [+] starting SOC simulation";
    Verilated::commandArgs(argc, argv);

    SysCon<Vsoc> soc("soc_trace.vcd");

    soc.warmup();

    for (size_t cycle = 0 ; cycle < 100 ; cycle++) {
        soc.tick();
    }

    return EXIT_SUCCESS;
}
