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

## Part&footprint

 - [Make components in KiCAD](http://docs.kicad-pcb.org/4.0.7/en/getting_started_in_kicad.html#make-schematic-components-in-kicad)
 - [quicklib](http://kicad.rohrbacher.net/quicklib.php)

## Libraries

 - https://github.com/open-project/kicadlibrary

## BOM

There isn't a predefined utilities for ``BOM`` generation: use [this](https://github.com/SchrodingersGat/KiBoM), in the
README there are the installation instruction.

## Differential pairs and length matching

 - https://olimex.wordpress.com/2015/03/03/kicad-now-with-differential-pair-routing-and-trace-length-matching/

## Links

 - [Wikibooks's FAQ](https://en.wikibooks.org/wiki/Kicad/FAQ)
 - [Pcbnew](https://wiki.xtronics.com/index.php/Pcbnew)
 - [Creating a Project From KiCAD Files](https://factory.macrofab.com/help/kpdink)
 - [Tutorial for kicad](http://store.curiousinventor.com/guides/kicad)
 - [Importing Libraries into KiCad](http://www.accelerated-designs.com/help/KiCad_Library.html)
 - [Several useful libraries of components](http://smisioto.no-ip.org/elettronica/kicad/kicad-en.htm)
 - [Preparing PCB for SeeedStudio](http://support.seeedstudio.com/knowledgebase/articles/1824574-how-to-generate-gerber-and-drill-files-from-kicad)
 - [Preparing PCB for PCBway](https://www.pcbway.com/blog/help_center/Generate_Gerber_file_from_Kicad.html)
 - [Preparing PCB for JLCPCB](https://support.jlcpcb.com/article/149-how-to-generate-gerber-and-drill-files-in-kicad)
 - [OSH Park design rules for Kicad](http://docs.oshpark.com/design-tools/kicad/kicad-design-rules/)
 - [TECHNIQUES, TIPS AND WORK-AROUNDS](https://flyingcarsandstuff.com/2016/10/kicad-techniques-tips-and-work-arounds/)
 - [Via Stitching In KiCad (without traces)](https://www.youtube.com/watch?v=Hp5ngKtl7S4)
 - [yaqwsx/PcbDraw](https://github.com/yaqwsx/PcbDraw) Convert your KiCAD board into a nicely looking 2D drawing suitable for pinout diagrams
 - [pointhi/kicad-color-schemes](https://github.com/pointhi/kicad-color-schemes)
 - [yaqwsx/KiKit](https://github.com/yaqwsx/KiKit) Automation tools for KiCAD
 - [stimulu/stimulu-kicad-plugins](https://github.com/stimulu/stimulu-kicad-plugins) KiCad plugins to reproduce or use Stimulu board files
 - [Connect pins with KiCad Bus, Labels, and Global Labels](https://www.baldengineer.com/kicad-bus-labels-and-global-labels.html)
 - [LAYOUT FILES: KiCad footprints useful for PCB panelization (mouse-bites...)](https://github.com/madworm/Panelization.pretty)
 - [KiCad 5 (Part 23) Using a Net Tie](https://www.youtube.com/watch?v=7uGGPNSqA-A)
 - [kicadStepUp-WB](https://github.com/easyw/kicadStepUpMod) KiCad StepUp tools are a FreeCAD Macro and a FreeCAD WorkBench to help in Mechanical Collaboration between KiCad EDA and FreeCAD or a Mechanical CAD.
 - [svg2mod](https://github.com/svg2mod/svg2mod) convert SVG drawings to KiCad footprint module files
