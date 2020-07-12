#include <stdlib.h>
#include <vector>
#include <sstream>
#include <stdexcept>
#include "Vcpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#define _WISHBONE_
#include "peripherals.h"
#include <assembly.h>

#define LOG(...) fprintf(stderr, __VA_ARGS__)

const char* STATES[] = {
    "FETCH",
    "DECODE",
    "EXECUTE",
    "STORE",
};


#define EMPTY_REGISTERS {}

/* contains the values to assert */
struct reg_state {
    uint8_t idx;
    uint32_t value;
};

typedef unsigned short flags_state;

/*
 * This function checks the correct functioning of an instruction.
 *
 * cpu: instance of the cpu
 * mnemonic: string containing the instruction to execute
 * fstart: the starting state of the flags register
 * start: the state of the register at the fetch stage (what not indicate is zero)
 * fend: the ending state of the flags register
 * end: the registers that have changed (what not indicate is equal at the state indicate in start)
 */
void do_instruction(const std::string mnemonic, flags_state fstart, std::vector<reg_state> start, flags_state fend, std::vector<reg_state> end) {
    /* save to a custom trace */
    std::stringstream tracename;
    tracename << mnemonic << ".vcd";
    SysCon<Vcpu>* cpu = new SysCon<Vcpu>(tracename.str().c_str());

    cpu->warmup();
    /* initialize the instruction */
    ISA::Instruction instructionA(mnemonic);

    LOG(" [#] instruction \'%s\': %08x\n", mnemonic.c_str(), instructionA.getEncoding());

    // save the registers and flags
    cpu->cpu__DOT__flags = fstart;
    cpu->cpu__DOT__inner_flags = fstart;
    //cpu->cpu__DOT___flags = fstart;
    uint32_t* registers = (uint32_t*)malloc(sizeof(cpu->cpu__DOT__registers));
    memset(cpu->cpu__DOT__registers, 0x00, sizeof(cpu->cpu__DOT__registers));

    for (reg_state r: start) {
        cpu->cpu__DOT__registers[r.idx] = r.value;
    }
    memcpy(registers, cpu->cpu__DOT__registers, sizeof(cpu->cpu__DOT__registers));
    memcpy(cpu->cpu__DOT__inner_registers, cpu->cpu__DOT__registers, sizeof(cpu->cpu__DOT__registers));

    cpu->device->i_data = instructionA.getEncoding();
    // fetch
    cpu->tick();

    cpu->device->i_wb_ack = 1;

    // decode
    cpu->tick();

    cpu->device->i_wb_ack = 0;
    // execute
    cpu->tick();

    // store
    cpu->tick();

    // store
    cpu->tick();

    // store
    cpu->tick();

    for (uint index = 0 ; index < sizeof(cpu->cpu__DOT__registers)/sizeof(cpu->cpu__DOT__registers[0]); index++) {
        uint32_t finalValue = registers[index];
        for (std::vector<reg_state>::iterator it = end.begin(); it != end.end() ; it++) {
            if (index == it->idx) {
                finalValue = it->value;
                break;
            }
        }

        uint32_t actualValue = cpu->cpu__DOT__registers[index];

        if (actualValue != finalValue) {
            std::stringstream ss;
            ss << "fatal: expected for r" << std::hex << index << ":" << std::hex << finalValue << " obtained: " << std::hex << actualValue;
            throw std::runtime_error(ss.str());
        }
    }

    if (fend != cpu->cpu__DOT__flags) {
        std::stringstream ss;
        ss << "fatal: expected for flags: " << std::hex << fend << " obtained: " << std::hex << cpu->cpu__DOT__flags;
        throw std::runtime_error(ss.str());
    }

    free(registers);
    delete cpu->device;
}

int main(int argc, char* argv[]) {
    LOG(" [+] starting CPU simulation\n");
    Verilated::commandArgs(argc, argv);

    Verilated::traceEverOn(true);


    do_instruction(cpu, "ldids r7, 1af", 0xefab, EMPTY_REGISTERS, 0xefa0, {
        { .idx = 0, .value = 0x00000004},
        { .idx = 7, .value = 0x1af}
    });
    do_instruction(cpu, "jr r8", 0x1d34, {{.idx = 8, .value = 0xcafebabe}}, 0x1d34, {
        { .idx = 0, .value = 0xcafebabe},
    });

    do_instruction(cpu, "jrl r9", 0xcafe, {{.idx = 9, .value = 0xbabe7007}}, 0xcafe, {
        { .idx = 0, .value = 0xbabe7007},
        { .idx = 15, .value = 0x04},
    });

    do_instruction(cpu, "add r9, r7, r10",
    0xcafe, {
        {.idx = 7, .value = 0x00000002},
        {.idx = 10, .value = 0x00000001}},
    0xcafe, {
        { .idx = 0, .value = 0x04},
        { .idx = 9, .value = 0x03},
    });

    return EXIT_SUCCESS;
}
