# KiCad

[Home](http://kicad-pcb.org/) | [Doc](http://kicad-pcb.org/help/documentation/)

It's a CAD design software for electronic circuits.

## Installation

    # apt-get install kicad

After that you (maybe) should update your library

    $ WORKING_TREES=$PWD/kicad  ./library-repos-install.sh --install-or-update

## Quick introduction

 - EEschema (generate netlist)
 - CvPcb
 - Pvbnew: read netlist (from toolbar)

## Board outline

It's used the layer named **Edge cutes**

## Fill

Select **Add filled zones**, draw a poligon and then right click and select **fill**

## Links

 - [Creating a Project From KiCAD Files](https://factory.macrofab.com/help/kpdink)
 - [Tutorial for kicad](http://store.curiousinventor.com/guides/kicad)
 - [Importing Libraries into KiCad](http://www.accelerated-designs.com/help/KiCad_Library.html)
 - [Several useful libraries of components](http://smisioto.no-ip.org/elettronica/kicad/kicad-en.htm)
