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

void LoadInstructionImpl::parseFlags() {

    /* the letter after the ld is the immediate/register */
    //char u_flag  = *mOpcode.substr(5, 1).c_str();

    short width;
    bool isUpper = false;
    char w_flag = 'w';

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

    mEncoded |= width << 26;
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
    mEncoded |= 1 << 24;
    mEncoded |= mROperand.immediate;
}

} // end ISA namespace
