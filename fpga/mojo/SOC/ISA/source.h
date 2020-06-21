/*
 * This class represents the unit of code read from a file.
 *
 * It's internally organized for line, that can be a comment, empty,
 * label or code.
 *
 * A label is a reference to a particular line/address, until "assembling" is
 * not defined and hence is a relative value expressed "in lines" (including
 * comments, empty, etc...?).
 *
 */
#include <vector>
#include <fstream>
#include <map>


class Comment {
};

class Label {
};

class Code {
};

class Line {
    public:
        enum LineType {
            EMPTY,
            COMMENT,
            DIRECTIVE,
            LABEL,
            CODE,
        };

        Line(const char* line, size_t n, size_t nc);
        LineType type() { return mType; };
        std::vector<std::string> unknowns() { return mUnknowns; };
        void setCodeLine(size_t);
        uint32_t reference();
        std::string label() { return mLabel; }
        void update(size_t address, std::vector<size_t> values) {
            if (values.size() != mUnknowns.size()) {
                throw std::runtime_error("values have not the same size as the unknowns");
            }
            mAddress = address;
            mValues = values; /* set the unknowns */
        };
        std::string encode();
    private:
        size_t mN;
        size_t mCodeN;
        std::string mLine;
        size_t mAddress; /* where is positionated in memory (only for CODE type) */
        std::vector<std::string> mUnknowns;
        std::vector<size_t> mValues;
        uint32_t mReference; /* for the label */
        std::string mLabel;
        std::string mDirective;
        LineType mType;
        LineType getType(const char*);
        void preprocess();
};

class Source {
    private:
        size_t mStartingAddress = 0;
        size_t mCount = 0;
        size_t mCountCode = 0;
        std::vector<Line> mLines;
        std::map<std::string, size_t> mLabels;
        void preprocess(std::ifstream& stream);
        void preprocessType(Line& l);
        void resolve();
    public:
        Source(std::ifstream& stream, size_t startingAddress = 0);
        std::string encode();
};
