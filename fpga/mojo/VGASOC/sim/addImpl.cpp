#include <stdexcept>
#include <sstream>
#include "assembly.h"


namespace ISA{

extern short opcodes[];

void AddInstructionImpl::parseOpcode() {
    mEncoded  = opcodes[Instruction::ADD] << 28;
    if (mOpcode[3] == 'u') {
        mIsUpper = true;
    }
}

void AddInstructionImpl::validate() {
    if (mLOperand.type != OperandType::REGISTER) {
        throw std::runtime_error("add needs a register as destination operand");
    }
    if (mROperand.type != OperandType::REGISTER) {
        throw std::runtime_error("add needs a register as first source operand");
    }
    if (mXOperand.type != OperandType::REGISTER) {
        throw std::runtime_error("add needs a register as second source operand");
    } else if (mXOperand.reg < 8) {
        std::stringstream ss;
        ss << "the second source operand (" << mStrXOperand << ") must be a register with index greater than 7";
        throw std::runtime_error(ss.str());
    }
}

void AddInstructionImpl::encode() {
    mEncoded |= mLOperand.reg << 24;
    mEncoded |= mROperand.reg << 20;
    mEncoded |= (~0x80 & mXOperand.reg ) << 16;
    mEncoded |= mIsUpper << 19;
}

} // end namespace ISA
