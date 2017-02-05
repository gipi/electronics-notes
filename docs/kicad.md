# KiCad

[Home](http://kicad-pcb.org/) | [Doc](http://kicad-pcb.org/help/documentation/) | [Kicadlib.org](http://kicadlib.org)

It's a CAD design software for electronic circuits.

## Installation

    # apt-get install kicad

After that you (maybe) should update your library

    $ WORKING_TREES=$PWD/kicad  ./library-repos-install.sh --install-or-update

## Quick introduction

 - EEschema (generate netlist)
 - CvPcb
 - Pvbnew: read netlist (from toolbar)

![](http://docs.kicad-pcb.org/stable/en/images/kicad_flowchart.png)

## Board outline

It's used the layer named **Edge cutes**

## Layers

 - *.Cu: is the copper
 - *.Adhes
 - *.Silk
 - *.Mask
 - *.CrtYd keepout regions
 - *.Fab and Margin are for fab indications
 - Edge.Cuts indicates the board layout
 - Cmts.User comments and indications
 - Dwgs.User stuffs not to go to the silkscreen
 - Eco1.User and Eco2.User 

## Fill

Select **Add filled zones**, draw a poligon and then right click and select **fill**

## Graphics

 - [Sizing logo](http://www.deferredprocrastination.co.uk/blog/2016/kicad-logo-size/)
 - [PCB artwork in kicad](http://blog.komar.be/making-pcb-artwork-in-kicad/) a little outdated

## Libraries

 - https://github.com/open-project/kicadlibrary

## Links

 - [Wikibooks's FAQ](https://en.wikibooks.org/wiki/Kicad/FAQ)
 - [Pcbnew](https://wiki.xtronics.com/index.php/Pcbnew)
 - [Creating a Project From KiCAD Files](https://factory.macrofab.com/help/kpdink)
 - [Tutorial for kicad](http://store.curiousinventor.com/guides/kicad)
 - [Importing Libraries into KiCad](http://www.accelerated-designs.com/help/KiCad_Library.html)
 - [Several useful libraries of components](http://smisioto.no-ip.org/elettronica/kicad/kicad-en.htm)
 - [Preparing PCB for SeeedStudio](http://www.sl-alex.com.ua/en/page/kicad-preparing-pcb-for-seeedstudio)
 - [OSH Park design rules for Kicad](http://docs.oshpark.com/design-tools/kicad/kicad-design-rules/)
 - [TECHNIQUES, TIPS AND WORK-AROUNDS](https://flyingcarsandstuff.com/2016/10/kicad-techniques-tips-and-work-arounds/)
