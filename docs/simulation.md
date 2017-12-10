# Simulation

## Spice

 - [NGSpice user manual](http://ngspice.sourceforge.net/docs/ngspice25-manual.pdf)
 - [SPICE ‘Quick’ Reference Sheet](https://web.stanford.edu/class/ee133/handouts/general/spice_ref.pdf)
 - [Simulationg Kicad schematics in KiCAD](https://stffrdhrn.github.io/electronics/2015/04/28/simulating_kicad_schematics_in_spice.html)
 - [Writing Simple Spice Netlists](http://eee.guc.edu.eg/Courses/Electronics/ELCT503%20Semiconductors/Lab/spicehowto.pdf)
 - [NGSPICE- Usage and Examples](https://www.ee.iitb.ac.in/course/~dghosh/ngspice-2.pdf)
 - [Examples of standard circuit with SPICE simulation](https://ashwith.wordpress.com/2010/09/21/simulating-circuits-more-examples/)

```
* inductive lowpass filter  (https://www.allaboutcircuits.com/textbook/alternating-current/chpt-8/low-pass-filters/)

l1 1 2 3
rload 2 0 1k    

v1 1 0 ac 1 

.control
  ac lin 20 1 200
  set hcopydevtype=postscript
  hardcopy temp.ps V(2) xl 1hz 100Hz
.endc

.end
```
