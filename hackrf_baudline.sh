#!/bin/bash
# ./hackrf_baudline.sh <frequency> <samplerate> <ifgain> <bbgain>
# Original from <https://www.elttam.com.au/blog/intro-sdr-and-rf-analysis/>

# Pipe HackRF output to Baudline
hackrf_transfer -r - -f ${1} -s ${2} -l ${3} -g ${4} | baudline -reset -basefrequency ${1} -samplerate ${2} -channels 2 -format s8 -quadrature -flipcomplex -stdin
