/*
 * Quick&dirty assembler for our made-up ISA.
 */
#include <iostream> // FIXME
#include <stdexcept>
#include <sstream>
#include "assembly.h"

#define OP(a,b) (a | (b << 8))

namespace ISA {

extern short opcodes [];

size_t LoadInstructionImpl::parseFlags() {

    /* the letter after the ld is the immediate/register */
    char ir_flag = *mOpcode.substr(2, 1).c_str();
    char dm_flag = *mOpcode.substr(3, 1).c_str();
    char w_flag  = *mOpcode.substr(4, 2).c_str();
    char u_flag  = *mOpcode.substr(5, 1).c_str();

    bool isImmediate;
    bool isDirect;
    short width;
    bool isUpper = false;

    switch (ir_flag) {
        case 'i':
            isImmediate = true;
            break;
        case 'r':
            isImmediate = false;
            break;
        default:
            throw std::runtime_error("After 'ld' only 'i' or 'r' are admitted!");
    }

    switch (dm_flag) {
        case 'd':
            isDirect = true;
            break;
        case 'm':
            isDirect = false;
            break;
        default:
            throw std::runtime_error("Only 'd' and 'm' are admitted!");
    }

    switch (w_flag) {
        case 'b':
            width = 0;
            break;
        case 's':
            width = 1;
            break;
        case 'w':
            width = 2;
            break;
        default:
            throw std::runtime_error("Only 'b', 's' and 'w' are admitted!");
    }

    size_t off = 5; /* pont to the space part of the mnemonic */

    /* now we can have the 'u' letter if is immediate */
    if (u_flag == 'u' && isImmediate) {
        isUpper = true;
        off++;
    }

    mEncoded |= isImmediate << 27;
    mEncoded |= isDirect << 26;
    mEncoded |= width << 24;

    return off;
}

void LoadInstructionImpl::parseOpcode() {
    mEncoded  = opcodes[Instruction::LOAD] << 28;
    parseFlags();
}

void LoadInstructionImpl::validate() {
    if (mLOperand.type != OperandType::REGISTER) {
        throw std::runtime_error("validate: load instruction must have a register as a left operand");
    }
}

void LoadInstructionImpl::encode() {
    mEncoded |= mLOperand.reg << 20;
    mEncoded |= mROperand.immediate;
}

} // end ISA namespace
