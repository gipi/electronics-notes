#include <stdexcept>
#include <sstream>
#include "assembly.h"

namespace ISA {
extern short opcodes[];

void MulInstructionImpl::encode() {
    mEncoded  = opcodes[Instruction::MUL] << 28;
    mEncoded |= mLOperand.reg << 20;
    mEncoded |= mROperand.reg << 16;
}

void MulInstructionImpl::validate() {
    if (mLOperand.type != REGISTER && mROperand.type != REGISTER) {
        std::stringstream ss;

        ss << "mul instruction takes two registers as arguments";
        throw std::runtime_error(ss.str());
    }
}

}
