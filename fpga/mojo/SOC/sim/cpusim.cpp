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

typedef struct {
    int carry;
    int zero;
    int sign;
    int overflow;
} flags_state;

typedef struct {
    uint32_t o_wb_addr;
    uint32_t i_wb_data;
} wb_transaction_t;

#define WB_NO_TRANSACTION {.o_wb_addr = 0xffffffff, .i_wb_data = 0xffffffff}

#define wb_is_there_transaction(wb) ((wb).o_wb_addr != 0xffffffff)

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
void do_instruction(const std::string mnemonic, flags_state fstart, std::vector<reg_state> start, flags_state fend, std::vector<reg_state> end, wb_transaction_t wb_transaction = WB_NO_TRANSACTION) {
    /* save to a custom trace */
    std::stringstream tracename;
    tracename << mnemonic << ".vcd";
    SysCon<Vcpu>* cpu = new SysCon<Vcpu>(tracename.str().c_str());

    cpu->warmup();
    /* initialize the instruction */
    ISA::Instruction instructionA(mnemonic);

    LOG(" [#] instruction \'%s\': %08x\n", mnemonic.c_str(), instructionA.getEncoding());

    // save the registers and flags
    cpu->device->cpu__DOT__carry = fstart.carry;
    cpu->device->cpu__DOT__zero = fstart.zero;
    cpu->device->cpu__DOT__sign = fstart.sign;
    cpu->device->cpu__DOT__overflow = fstart.overflow;
    cpu->device->cpu__DOT__inner_carry = fstart.carry;
    //cpu->device->cpu__DOT___flags = fstart;
    uint32_t* registers = (uint32_t*)malloc(sizeof(cpu->device->cpu__DOT__registers));
    memset(cpu->device->cpu__DOT__registers, 0x00, sizeof(cpu->device->cpu__DOT__registers));

    for (reg_state r: start) {
        cpu->device->cpu__DOT__registers[r.idx] = r.value;
    }
    memcpy(registers, cpu->device->cpu__DOT__registers, sizeof(cpu->device->cpu__DOT__registers));
    memcpy(cpu->device->cpu__DOT__inner_registers, cpu->device->cpu__DOT__registers, sizeof(cpu->device->cpu__DOT__registers));

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

    if (wb_is_there_transaction(wb_transaction)) {
        if (!cpu->device->o_wb_stb) {
            std::stringstream ss;
            ss << "fatal: I was expecting a strobe signal for the wishbone transaction";
            throw std::runtime_error(ss.str());
        }
        uint32_t address_requested = cpu->device->o_wb_addr;

        if (address_requested != wb_transaction.o_wb_addr) {
            std::stringstream ss;
            ss << "fatal: expected access to memory at " << std::hex << wb_transaction.o_wb_addr << " instead have been requested address " << std::hex << address_requested;
            throw std::runtime_error(ss.str());
        }
        /* set the response from the slave */
        cpu->device->i_wb_ack = 1;
        cpu->device->i_data = wb_transaction.i_wb_data;
        // store
        cpu->tick();
        cpu->device->i_wb_ack = 0;
        cpu->tick();
        cpu->tick();
    }

    if (cpu->device->cpu__DOT__enable_fetch != 1) {
        std::stringstream ss;
        ss << "fatal: at the end of the instruction enable_fetch is not asserted";
        throw std::runtime_error(ss.str());
    }

    // store
    //cpu->tick();

    /* check registers */
    for (uint index = 0 ; index < sizeof(cpu->device->cpu__DOT__registers)/sizeof(cpu->device->cpu__DOT__registers[0]); index++) {
        uint32_t finalValue = registers[index];
        for (std::vector<reg_state>::iterator it = end.begin(); it != end.end() ; it++) {
            if (index == it->idx) {
                finalValue = it->value;
                break;
            }
        }

        uint32_t actualValue = cpu->device->cpu__DOT__registers[index];

        if (actualValue != finalValue) {
            std::stringstream ss;
            ss << "fatal: expected for r" << std::hex << index << ":" << std::hex << finalValue << " obtained: " << std::hex << actualValue;
            throw std::runtime_error(ss.str());
        }
    }

    /* check flags */
    if (fend.carry != cpu->device->cpu__DOT__carry) {
        std::stringstream ss;
        ss << "fatal: expected for CARRY: " << std::hex << fend.carry << " obtained: " << std::hex << static_cast<int>(cpu->device->cpu__DOT__carry);
        throw std::runtime_error(ss.str());
    }
    if (fend.zero != cpu->device->cpu__DOT__zero) {
        std::stringstream ss;
        ss << "fatal: expected for ZERO: " << std::hex << fend.zero << " obtained: " << std::hex << static_cast<int>(cpu->device->cpu__DOT__zero);
        throw std::runtime_error(ss.str());
    }
    if (fend.sign != cpu->device->cpu__DOT__sign) {
        std::stringstream ss;
        ss << "fatal: expected for SIGN: " << std::hex << fend.sign << " obtained: " << std::hex << static_cast<int>(cpu->device->cpu__DOT__sign);
        throw std::runtime_error(ss.str());
    }
    if (fend.overflow != cpu->device->cpu__DOT__overflow) {
        std::stringstream ss;
        ss << "fatal: expected for OVERFLOW: " << std::hex << fend.overflow << " obtained: " << std::hex << static_cast<int>(cpu->device->cpu__DOT__overflow);
        throw std::runtime_error(ss.str());
    }

    free(registers);
    delete cpu->device;
}

#define FLAGS_ALL_SET {.carry = 1, .zero = 1, .sign = 1, .overflow = 1}
#define FLAGS_ALL_NOT_SET {.carry = 0, .zero = 0, .sign = 0, .overflow = 0}
int main(int argc, char* argv[]) {
    LOG(" [+] starting CPU simulation\n");
    Verilated::commandArgs(argc, argv);

    Verilated::traceEverOn(true);

    do_instruction("ldids r7, 1af", FLAGS_ALL_SET,  EMPTY_REGISTERS, FLAGS_ALL_SET , {
        { .idx = 0, .value = 0x00000004},
        { .idx = 7, .value = 0x1af}
    });
    do_instruction("ld r7, [r10]", FLAGS_ALL_SET,  {{.idx = 10, .value = 0xabad1dea}}, FLAGS_ALL_SET , {
        { .idx = 0, .value = 0x00000004},
        { .idx = 7, .value = 0xcafebabe}
    }, {.o_wb_addr = 0xabad1dea, .i_wb_data = 0xcafebabe});
    do_instruction("jr r8", FLAGS_ALL_SET, {{.idx = 8, .value = 0xcafebabe}}, FLAGS_ALL_SET, {
        { .idx = 0, .value = 0xcafebabe},
    });

    do_instruction("jrl r9", FLAGS_ALL_SET, {{.idx = 9, .value = 0xbabe7007}}, FLAGS_ALL_SET, {
        { .idx = 0, .value = 0xbabe7007},
        { .idx = 15, .value = 0x04},
    });

    do_instruction("add r9, r7, r10",
    FLAGS_ALL_SET, {
        {.idx = 7, .value = 0x00000002},
        {.idx = 10, .value = 0x00000001}},
    FLAGS_ALL_NOT_SET, {
        { .idx = 0, .value = 0x04},
        { .idx = 9, .value = 0x03},
    });
    do_instruction("add r9, r7, r10",
    FLAGS_ALL_NOT_SET, {
        {.idx = 7, .value = 0xffffffff},
        {.idx = 10, .value = 0x00000001}},
    {.carry = 1, .zero = 1, .sign = 0, .overflow = 0}, {
        { .idx = 0, .value = 0x04},
        { .idx = 9, .value = 0x00},
    });

    return EXIT_SUCCESS;
}
