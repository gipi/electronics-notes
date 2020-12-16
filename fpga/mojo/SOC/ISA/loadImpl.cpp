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
    std::string::size_type indexU = mOpcode.find('u');

    short width;
    bool isUpper = (indexU != std::string::npos);
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
    mEncoded |= isUpper << 25;
}

void LoadInstructionImpl::parseOpcode() {
    mEncoded  = opcodes[Instruction::LOAD] << 28;
    parseFlags();
}

void LoadInstructionImpl::validate() {
    if (mLOperand.type != OperandType::REGISTER) {
        throw std::runtime_error("validate: load instruction must have a register as a left operand");
    }
    if (mROperand.type != OperandType::IMMEDIATE
            && mROperand.type != OperandType::REFERENCE_REGISTER
            && mROperand.type != OperandType::REFERENCE_REGISTER_OFFSET) {
        throw std::runtime_error("validate: load instruction must have an immediate or a reference  as a right operand");
    }
}

void LoadInstructionImpl::encode() {
    if (mROperand.type == REFERENCE_REGISTER || mROperand.type == REFERENCE_REGISTER_OFFSET) {
        mEncoded |= mROperand.offset;
    } else {
        mEncoded |= 1 << 24;
        mEncoded |= mROperand.immediate;
    }
    mEncoded |= mLOperand.reg << 20;
    mEncoded |= mROperand.reg << 16;
}

} // end ISA namespace
