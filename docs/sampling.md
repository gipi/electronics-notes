# Sampling&ADC

You need to transform analog input from the real world to something digestible
to the digital world.

Some definition:

 - **Signal to noise ratio:** \\(\hbox{SNR} = {P_\hbox{signal}\over P_\hbox{noise}}\\)
 - **Effective number of bits:** indicated as **ENOB**

this holds
([calculation](https://en.wikipedia.org/wiki/Signal-to-noise_ratio#Fixed_point))
$$
\hbox{SNR}(db) = 6.02\cdot\hbox{ENOB} + 1.76
$$

## Nyquist-Shannon sampling theorem

Signals that differs of \\({1\over T}\\) are sampled the same

 - [Sampling: What Nyquist Didn’t Say, and What to Do About It](http://www.wescottdesign.com/articles/Sampling/sampling.pdf)

## Oversampling and decimation

In same cases you can improve the resolution of your ``ADC`` of \\(n\\) bits
simply summing together \\(f_\hbox{oversampling} = 4^n \cdot f_{\hbox{sampling}}\\)
and then scaling by a factor of \\(s = 2^n\\). This is possible if the following
assumptions hold

 - the signal of interest should not vary significantly during a conversion
 - there should some noise in the signal with amplitude at least 1 ``LSB``

## Links

 - [Getting the most out of the SAM D21's ADC](https://blog.thea.codes/getting-the-most-out-of-the-samd21-adc/)
 - [AVR121: Enhancing ADC resolution by oversampling](http://ww1.microchip.com/downloads/en/appnotes/doc8003.pdf)
 - [AN118: IMPROVING ADC RESOLUTION BY OVERSAMPLING AND AVERAGING](https://www.silabs.com/documents/public/application-notes/an118.pdf)
 - [Understand SINAD, ENOB, SNR, THD, THD + N, and SFDR so You Don't Get Lost in the Noise Floor](https://www.analog.com/media/en/training-seminars/tutorials/MT-003.pdf)
