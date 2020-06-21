#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <plog/Log.h>
#include "source.h"
#include "assembly.h"


/* 
 * FIXME: makes sense to pass line/code number? maybe is better that Source
 * instance update() the address (think of different sections defined by a
 * directive).
 */
Line::Line(const char* line, size_t n, size_t nc) : mLine(line), mN(n), mCodeN(nc) {
    mType = getType(line);
    preprocess();
}

/* calculate the unknowns */
void Line::preprocess() {
    switch (mType) {
        case EMPTY:
            break;
        case CODE: {
            // look for variable (words starting with "$")
            std::string::size_type indexDollar = mLine.find('$');
            if (indexDollar != std::string::npos) {
                // it will be terminated by a space or the end of the string
                std::string::size_type indexSpace = mLine.find(' ', indexDollar + 1);
                std::string unknown = mLine.substr(
                    indexDollar + 1,
                    indexSpace != std::string::npos ?
                    indexSpace - indexDollar - 1 : mLine.size() - indexDollar - 1);
                PLOG_DEBUG << "found unknown '" << unknown << "'";
                mUnknowns.push_back(unknown);
           }
           break;
        }
        case COMMENT:
           break;
        case DIRECTIVE: {
           // TODO: create class Directive that like Instruction handles direct
           // data representation
           std::string directive(mLine);
           if (directive.find(".word") != std::string::npos) {
               mDirective = directive.substr(6);
               PLOG_DEBUG << "found directive '" << mDirective;
           }
           break;
        }
        case LABEL: {
           std::string::size_type indexColon = mLine.find(':');
           if (indexColon == std::string::npos) {
               throw std::runtime_error("type LABEL but colon it's nowhere to be found!");
           }
           mLabel = mLine.substr(0, indexColon);
           PLOG_DEBUG << "label='" << mLabel << "'";
            mReference = mCodeN;
            break;
        }
    }
}

Line::LineType Line::getType(const char* line) {
    if (line[0] == '#') {
        PLOG_DEBUG << "found COMMENT";
        return COMMENT;
    } else if (line[0] == '.') {
        PLOG_DEBUG << "found DIRECTIVE";
        return DIRECTIVE;
    } else if (line[0] == '\0') {
        PLOG_DEBUG << "found EMPTY";
        return EMPTY;
    } else if (mLine.find(':') != std::string::npos) {
        PLOG_DEBUG << "found LABEL";
        return LABEL;
    }

    return CODE;
}

void Line::setCodeLine(size_t n) {
    mCodeN = n;
}

/* TODO: pass as argument the way we want to encode, namely
 *
 *  1. hex
 *  2. binary
 *  3. debug info: this format could be something like 0xb000003c: 183e0000 ld r3, [r14]
 */
std::string Line::encode() {
    PLOG_DEBUG << "encoding line '" << mLine << "'";
    std::stringstream ss;
    switch (type()) {
        case CODE: {
            std::string instr = mLine;
            /* 
             * TODO: move resolution to the instruction itself, in particular
             * add an operand type like REFERENCE_VARIABLE and call a method
             * on encoding with a map (variable, value)
             */
            for (size_t cycle = 0 ; cycle < mUnknowns.size() ; cycle++) {
                std::stringstream ssinstr;
                std::stringstream ss;
                std::string unknown = mUnknowns[cycle];
                ss << std::hex << mValues[cycle];
                std::string value = ss.str();
                /* without an AST we cannot substitute the string with another
                 * since they are probably of different lengths */
                std::string::size_type indexUnknown = instr.find(unknown) - 1; /* remember is $variable */
                std::string::size_type sizeUnknown = unknown.size() + 1;
                ssinstr << instr.substr(0, indexUnknown) << value << instr.substr(indexUnknown + sizeUnknown, instr.size() - indexUnknown - sizeUnknown);
                instr = ssinstr.str();
            }
            PLOG_DEBUG << "fixing unknowns: '" << mLine << "' -> '" << instr << "'";
            ISA::Instruction instruction(instr);
            ss << std::setfill('0') << std::setw(8) << std::hex << instruction.getEncoding() << std::endl;
            }
            break;
        case DIRECTIVE:
            ss << mDirective << std::endl;
            break;
    }
    PLOG_DEBUG << "encoded line as " << ss.str();
    return ss.str();
}

/*
 * The implementation is going to do its work in two steps: first read the
 * source code line by line to identify a very primitive AST and in the second
 * step it's going to resolve the labels.
 */
Source::Source(std::ifstream& stream, size_t startingAddress) : mStartingAddress(startingAddress) {
    preprocess(stream);
}

void Source::preprocessType(Line& l) {
    switch (l.type()) {
        case Line::LineType::CODE:
            mCountCode++;
            break;
        case Line::LineType::DIRECTIVE:
            mCountCode++; /* TODO: DIRECTIVE could handle more than one word */
            break;
        case Line::LineType::LABEL: /* FIXME: probably this code wih map is ugly :P */
            auto element = mLabels.find(l.label());

            if (element != mLabels.end()) {
                PLOG_FATAL << "a label named '" << l.label() << "' already exists at (code) line " << element->second;
            }
            mLabels.insert({l.label(), mCountCode});

            PLOG_DEBUG << "saved label '" << l.label() << "' at (code) line " << mCountCode;

            break;
    }
}

void Source::preprocess(std::ifstream& stream) {
    mCount = 0;
    mCountCode = 0;
    while (true) {
        char line[64];

        stream.getline(line, 63); /* FIXME: understand how behaves the count argument! */

        if (stream.fail()) {
            break;
        }
        PLOG_DEBUG << "line " << mCount << " (" << mCountCode << ") address=" <<
            std::hex << mStartingAddress + mCountCode * 4 << " : " << line;
        /* create an instance of Line that does its own preprocessing */
        Line l(line, mCount, mCountCode);
        /* extract info for global preprocessing (like labels) */
        preprocessType(l);
        mCount++;
        mLines.push_back(l);
    }
}

void Source::resolve() {
    PLOG_DEBUG << "resolving";
    size_t offset = 0;
    for (Line& line : mLines) {
        /* we are interested only in code line */
        if (line.type() != Line::LineType::CODE)
            continue;

        PLOG_DEBUG << "resolving for line";

        /* check we don't have unknowns */
        auto unknowns = line.unknowns();

        std::vector<size_t> values;
        /* and in case resolve it */
        if (unknowns.size() != 0) {
            for (std::string unknown : unknowns) {
                PLOG_DEBUG << "resolving label '" << unknown << "'";
                auto element = mLabels.find(unknown);
                if (element == mLabels.end()) {
                    std::stringstream ss;
                    ss << "label '" << unknown << "' cannot be resolved";
                    PLOG_FATAL << ss.str();
                    throw std::runtime_error(ss.str()); 
                }

                PLOG_DEBUG << "resolving '" << unknown << "' with " << std::hex << element->second;
                values.push_back(element->second);
            }
            /* tell the code what the values are*/
        }
        line.update(mStartingAddress + 4 * offset , values);
    }
}

std::string Source::encode() {
    resolve();
    std::stringstream ss;
    for (Line& line : mLines) {
        /* we are interested only in code line */
        if ((line.type() != Line::LineType::CODE) && (line.type() != Line::LineType::DIRECTIVE))
            continue;

        ss << line.encode();
    }

    return ss.str();
}
