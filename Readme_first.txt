This proposes a set of:
* Spool support, horizontal axis
* Filament guide
* Extruder support
For an aluminium profile frame
There are alternatives for installation on flat panels

The main purpose of this support was to have a steady traction without any braking system, and to avoid spool balancing.
When you are using a long Bowden tube and a tubular support, the high retraction drives to spool balancing, which can became significant on some type of infills at high speed. This may drive to filament tangling.
This support solve simply the problem by having a flat support, reclined against its arm, giving a steady braking effect.
In addition, the support is slightly angled toward the profile, for a more direct filament path.
It accepts spools of 50+ mm hole diameter and its width is sufficient for standard spools of 200mm and 170mm diameter.
You can modify parameters in OpenScad, however for spools over 1kg you may need a good extruder to have sufficient pulling force.

Miscellaneous outputs are located in the STL directory

PRINTING recommendations -------------------
 spool support and filament guide printed in PLA with 5 top/bottom layers, 5 walls and 30% infill
 Depending your setup you may want to mirror parts (in your slicer). 
 You have two different shapes for the spool support, one for aluminium profile and the other for installation on a panel
 
Layers 0.25mm for the spool support and 0.2 for the filament guide, though 0.25mm can be ok for the filament guide.
In the photos, the extruder plate was printed in PETG for better temperature resistance, as it is in contact with the stepper, which may became relatively warm. ABS or high temperature PLA is an alternative. 
 
== Modifying parts in OpenSCAD =================================
 To modify support and accessories, run Spool_side_slot.scad in OpenScad
Recent versions of OpenSCAD are needed, prefer the development snapshots:
http://www.openscad.org/downloads.html#snapshots
 
 You Shall select the part to display by modifying the part variable, either in the editor or with customizer.  [1:Spool support, 2:Filament guide, 3:Extruder support, 4:All]
 
 The option 5 is off-topic, this is the belt separator support for a CoreXY printer with crossed belts, set here because it was not deserving a whole directory in itself
 
CUSTOMIZER -------------------------------
 It may help to use OpenSCAD customizer
  Customizer is experimental feature, so you need to select:
  - Menu [Edit][Preferences][Features], tick [Customizer]
  - Menu [View] Untick [Hide customizer]-
 
 You shall use the last snapshot of OpenSCAD for proper operation of Customizer.  Minimal version: Snapshot 02 January 2018.  On Mac the version 23 Dec 2017 will probably work. Some bugs on included files. 
 
 Please note that there are still bugs in customizer and some options may not work, in this case you shall do direct modifications in the editor.
  
AUTHOR and Licenses ---------------------  
(c) Pierre ROUZEAU 2018
files in : https://github.com/PRouzeau/Spool_support_aluminium_frame
* Part licence : CERN OHL V1.2
* Program license GPL2 & 3
* Documentation licence : CC BY-SA

references
http://rouzeau.net/Print3D/

Author design note: 
This is my third spool support design, the simplest and most efficient one, starting from ball bearing based system with brakes to this much simpler stuff.

