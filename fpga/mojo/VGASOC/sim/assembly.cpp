/*
 * Quick&dirty assembler for our made-up ISA.
 */
#include <iostream> // FIXME
#include <stdexcept>
#include <sstream>
#include "assembly.h"

#define OP(a,b) (a | (b << 8))

namespace ISA {

short opcodes [] { /* you MUST set without jumps in the index [] otherwise fails to compile */
    [Instruction::LOAD] = 0x1,
    [Instruction::JUMP] = 0x3,
    [Instruction::STORE] = 0x7,
    [Instruction::ADD] =  0x4,
};


/*
 * This is the code that decides which instruction we are going to assemble.
 *
 * The generic structure of an instruction is "opcode operand1,operand2", and these
 * are the arguments passed to the XInstructionImpl constructor.
 */
void Instruction::parse() {
    short code = *(short*)mMnemonic.substr(0, 2).c_str();

    size_t indexSpace = mMnemonic.find(' ');
    size_t indexComma = mMnemonic.find(',');

    std::string opcode = "";
    std::string operand1 = "";
    std::string operand2 = "";
    std::string operand3 = "";

    if (indexSpace != std::string::npos) {
        opcode = mMnemonic.substr(0, indexSpace);
        operand1 = mMnemonic.substr(indexSpace + 1);
    }

    if (indexComma != std::string::npos) {
        operand1 = mMnemonic.substr(indexSpace + 1, indexComma - indexSpace);
        operand2 = mMnemonic.substr(indexComma + 1);
    }

    indexComma = operand2.find(',');
    if (indexComma != std::string::npos) {
        operand3 = operand2.substr(indexComma + 1);
        operand2 = operand2.substr(0, indexComma);
    }

    switch (code) {
        case OP('l', 'd'):
            mType = LOAD;
            mInstruction = new LoadInstructionImpl(opcode, operand1, operand2);
            break;
        case OP('j', 'r'):
            mType = JUMP;
            mInstruction = new JumpInstructionImpl(opcode, operand1, operand2);
            break;
        case OP('a', 'd'):
            mType = ADD;
            mInstruction = new AddInstructionImpl(opcode, operand1, operand2, operand3);
            break;
        default:
            std::stringstream ss;
            ss << "unimplemented opcode '" << opcode <<"'";
            throw std::runtime_error(ss.str());
    }

    mInstruction->parse();
}

/*
 * Generic method used to parse an operand.
 *
 * r8      --> register
 * 0xabc ----> immediate
 * [...] ----> reference
 */
Operand Instruction::parseOperand(const std::string operand) {
    bool isReference = false;

    Operand resultOperand = {
        .type = OperandType::EMPTY,
    };
    if (operand.empty()) { /* it's possible to have an empty operand, it's the instruction to tell if it's an error */
        return resultOperand;
    }
    std::string innerOperand = operand;
    /* TODO: trim whitespaces (seems that in C++ is like impossible to do wo magic) */
    if (operand[0] == '[') {
        /* we have an open bracket could be a reference */
        if (operand[operand.size() - 1] != ']') {
            std::stringstream ss;
            ss << "'" << operand << "' has not closing bracket";
            throw std::runtime_error(ss.str());
        }
        innerOperand = operand.substr(1, operand.size() - 2);
    }

    /* now we have the value parsable or as an immediate or as a register (+ offset) */
    /* TODO: this code is fragile */
    size_t indexR = innerOperand.find('r');
    if (indexR != std::string::npos) {
        size_t plusIndex = innerOperand.find('+');
        if (plusIndex == std::string::npos) {
            /* if starts with "r" and contain '+' then we have an offset */
            resultOperand.type = isReference ? OperandType::REFERENCE_REGISTER : OperandType::REGISTER;
            resultOperand.reg = atoi(innerOperand.substr(indexR + 1).c_str()); /* FIXME: check for errors */
        } else if (!isReference) {
            throw std::runtime_error("operand parsing: an immediate doesn't allow for offset");
        } else {
            resultOperand.type = OperandType::REFERENCE_REGISTER_OFFSET;
            resultOperand.reg = atoi(innerOperand.substr(1, plusIndex - 1).c_str());
            resultOperand.offset = atoi(innerOperand.substr(plusIndex + 1).c_str());
        }
    } else { /* if we are here then this is an immediate */
        char* endptr;
        uint32_t value = strtol(innerOperand.c_str(), &endptr, 16);

        if (endptr == innerOperand.c_str()) {
            throw std::runtime_error("operand parsing: immediate parsing impossible");
        }

        resultOperand.type = isReference ? OperandType::REFERENCE_IMMEDIATE : OperandType::IMMEDIATE;
        resultOperand.immediate = value;
    }

    return resultOperand;
}

Instruction::~Instruction() {
    delete mInstruction;
}

void InstructionImpl::parseLeftOperand() {
    mLOperand = Instruction::parseOperand(mStrLOperand);
}

void InstructionImpl::parseRightOperand() {
    mROperand = Instruction::parseOperand(mStrROperand);
}

void InstructionImpl::parseExtraOperand() {
    mXOperand = Instruction::parseOperand(mStrXOperand);
}

void InstructionImpl::parse() {
    parseOpcode();
    parseLeftOperand();
    parseRightOperand();
    parseExtraOperand();
    validate();
    encode();
}

} // end ISA namespace
