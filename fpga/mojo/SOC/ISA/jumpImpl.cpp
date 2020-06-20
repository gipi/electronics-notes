#include <stdexcept>
#include "assembly.h"


namespace ISA{

extern short opcodes[];

void JumpInstructionImpl::parseOpcode() {
    mEncoded  = opcodes[Instruction::JUMP] << 28;
    /*
     * We accept
     *
     *  - jr as absolute
     *  - jrr as relative
     *  - jrl saving link
     *  - jrrl relative saving link
     */
    if ((mOpcode.size() == 3 && mOpcode[2] == 'l') || (mOpcode.size() == 4 && mOpcode[3] == 'l')) {
        mIsLink = true;
    }
    if ((mOpcode.size() == 3 && mOpcode[2] == 'r') || (mOpcode.size() == 4 && mOpcode[2] == 'r')) {
        mIsRelative = true;
    }
}

void JumpInstructionImpl::validate() {
    if (mLOperand.type != OperandType::REGISTER) {
        throw std::runtime_error("jr needs a register as source operand");
    } else if (mLOperand.reg < 8) {
        throw std::runtime_error("jr needs a register above 7");
    }
    if (mROperand.type != OperandType::REGISTER) {
        if (mROperand.type != OperandType::EMPTY) {
            throw std::runtime_error("jr needs a register as destination operand");
        }
    } else if (mROperand.reg < 8) {
        throw std::runtime_error("jr needs a register above 7");
    }
}

void JumpInstructionImpl::encode() {
    mEncoded |= ((~0xf8) & mLOperand.reg) << 20;
    mEncoded |= (mROperand.type == OperandType::REGISTER ? ((~0xf8) & mROperand.reg) : 7) << 16;
    mEncoded |= mIsLink << 19;
    mEncoded |= mIsRelative << 23;
}

} // end namespace ISA
