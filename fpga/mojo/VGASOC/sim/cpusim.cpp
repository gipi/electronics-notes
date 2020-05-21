#include <stdlib.h>
#include <vector>
#include <sstream>
#include <stdexcept>
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

#define LOGCPU(c) LOG("state: %s\to_addr: %08x i_data: %08x instruction: %08x opcode: %02x next_state: %02x\n",\
    STATES[(c)->cpu__DOT__current_state], \
    (c)->o_addr,                  \
    (c)->i_data,                  \
    (c)->cpu__DOT__q_instruction, \
    (c)->cpu__DOT__q_opcode,      \
    (c)->cpu__DOT__next_state     \
);LOGREGISTERS(c)

void tick(Vcpu* cpu) {
    cpu->clk = 0;
    cpu->eval();

    cpu->clk = 1;
    cpu->eval();
}

/* contains the values to assert */
struct reg_check {
    uint8_t idx;
    uint32_t value;
};

void do_instruction(Vcpu* cpu, std::string mnemonic, std::vector<reg_check> constraints) {
    ISA::Instruction instructionA(mnemonic);

    LOG(" [#] instruction \'%s\': %08x\n", mnemonic.c_str(), instructionA.getEncoding());

    // save the registers and flags
    uint32_t* registers = (uint32_t*)malloc(sizeof(cpu->cpu__DOT__registers));
    memcpy(registers, cpu->cpu__DOT__registers, sizeof(cpu->cpu__DOT__registers));

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

    for (uint index = 0 ; index < sizeof(cpu->cpu__DOT__registers)/sizeof(cpu->cpu__DOT__registers[0]); index++) {
        uint32_t finalValue = registers[index];
        for (std::vector<reg_check>::iterator it = constraints.begin(); it != constraints.end() ; it++) {
            if (index == it->idx) {
                finalValue = it->value;
                break;
            }
        }

        uint32_t actualValue = cpu->cpu__DOT__registers[index];

        if (actualValue != finalValue) {
            std::stringstream ss;
            ss << "fatal: expected for r" << std::hex << index << ":" << finalValue << " obtained: " << actualValue;
            throw std::runtime_error(ss.str());
        }
    }

    free(registers);
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

    do_instruction(cpu, "ldids r7, 1af", {
        { .idx = 0, .value = 0xb0000004},
        { .idx = 7, .value = 0x1af}
    });
    do_instruction(cpu, "jrl r7", {
        { .idx = 0, .value = 0x1af},
    });

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
