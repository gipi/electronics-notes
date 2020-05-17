#include <stdlib.h>
#include "Vcpu.h"
#include "verilated.h"
#include "assembly.h"

#define LOG(...) fprintf(stderr, __VA_ARGS__)

const char* STATES[] = {
    "FETCH",
    "DECODE",
    "EXECUTE",
    "STORE",
};

#define LOGREGISTERS(c) do { \
    size_t __index = 0;               \
    for (__index = 0 ; __index < 16 ; __index++) { \
        if (__index && (__index % 4) == 0) {  \
            LOG("\n");                       \
        }                                    \
        LOG("\tr%-2lu 0x%08x", __index, (c)->cpu__DOT__registers[__index]); \
    }                                        \
    LOG("\n");                               \
} while(0)

#define LOGCPU(c) LOG("state: %s\to_addr: %08x i_data: %08x instruction: %08x opcode: %02x q_operand1: %03x q_operand2: %02x q_operand3: %02x next_state: %02x\n",\
    STATES[(c)->cpu__DOT__current_state], \
    (c)->o_addr,                  \
    (c)->i_data,                  \
    (c)->cpu__DOT__q_instruction, \
    (c)->cpu__DOT__q_opcode,      \
    (c)->cpu__DOT__q_operand1,    \
    (c)->cpu__DOT__q_operand2,    \
    (c)->cpu__DOT__q_operand3,    \
    (c)->cpu__DOT__next_state     \
);LOGREGISTERS(c)

void tick(Vcpu* cpu) {
    cpu->clk = 0;
    cpu->eval();

    cpu->clk = 1;
    cpu->eval();
}

int main(int argc, char* argv[]) {
    LOG(" [+] starting CPU simulation\n");
    Verilated::commandArgs(argc, argv);

    Vcpu* cpu = new Vcpu;

    uint64_t timetick = 0;

    cpu->reset = 0;
    LOGCPU(cpu);
    while(timetick < 10) {
        tick(cpu);

        LOGCPU(cpu);
        timetick++;
    }

    cpu->reset = 1;

    LOG(" [+] out of reset\n");

    std::string mnemonic = "ldids r7, 1af";

    ISA::Instruction instructionA(mnemonic);

    LOG(" [#] instruction \'%s\': %08x\n", mnemonic.c_str(), instructionA.getEncoding());

    cpu->i_data = instructionA.getEncoding();
    // fetch
    tick(cpu);
    LOGCPU(cpu);

    // decode
    tick(cpu);
    LOGCPU(cpu);

    // execute
    tick(cpu);
    LOGCPU(cpu);

    // store
    tick(cpu);
    LOGCPU(cpu);
    cpu->i_data = 0x30feb007;
    // fetch
    tick(cpu);
    LOGCPU(cpu);

    // decode
    tick(cpu);
    LOGCPU(cpu);

    // execute
    tick(cpu);
    LOGCPU(cpu);

    // store
    tick(cpu);
    LOGCPU(cpu);

    cpu->i_data = 0xabad1d34;
    // fetch
    tick(cpu);
    LOGCPU(cpu);

    // decode
    tick(cpu);
    LOGCPU(cpu);

#if 0
    while(1) {
    tick(cpu);
    LOGCPU(cpu);
    }
#endif

    return EXIT_SUCCESS;
}
