#include <stdexcept>
#include "assembly.h"


namespace ISA{

extern short opcodes[];

void JumpInstructionImpl::parseOpcode() {
    mEncoded  = opcodes[Instruction::JUMP] << 28;
    if ((mOpcode.size() == 3 && mOpcode[2] == 'l') || (mOpcode.size() == 4 && mOpcode[3] == 'l')) {
        mIsLink = true;
    }
    if ((mOpcode.size() == 3 && mOpcode[2] == 'r') || mOpcode.size() == 4 && mOpcode[3] == 'r') {
        mIsRelative = true;
    }
}

void JumpInstructionImpl::validate() {
    if (mLOperand.type != OperandType::REGISTER) {
        throw std::runtime_error("jr needs a register as source operand");
    }
    if (mROperand.type != OperandType::EMPTY && mROperand.type != OperandType::REGISTER) {
        throw std::runtime_error("jr needs a register as destination operand");
    }
}

void JumpInstructionImpl::encode() {
    mEncoded |= mLOperand.reg << 20;
    mEncoded |= (mROperand.type == OperandType::REGISTER ? mROperand.reg : 7) << 16;
    mEncoded |= mIsLink << 19;
    mEncoded |= mIsRelative << 23;
}

} // end namespace ISA
