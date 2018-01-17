include <Z_library.scad>
//include <../Openscad/Utilities/X_utils.scad>

/* Spool support, filament guide and extruder plate support for 3D printer built in aluminium profiles. 

INSTALLATION -------------------------------
  The spool support is adapted for spools with 50mm diameter hole. The default spool maximum width is 80mm, which is ok for 200 and 170mm diameter standard spools. This can be modified, though heavy spools may need stronger materials than PLA
    While it was designed to be installed on aluminium profile, you have an option for installation on flat panels.
  
  The bowden extruder installation is designed for side spool installation and extruder facing you. This is the most practical setup for operation and maintenance, as it was done for the TronXY X5S which large size don't allow easy access to the back of the machine. This setup also allow to slightly shorten the Bowden tube, which is always a positive.

 By default, it is adapted for 2040 beams, bolted in the internal slot, you can extend the support arm length  (default 55 mm) if you have to install it on 2020 profile. 
 
PRINTING recommendations -------------------
 Printed in PLA with 5 top/bottom layers, 5 walls and 30% infill
 Depending your installation you may want to mirror parts (in your slicer). 
 You have two different shapes for the spool support, one for aluminium profile and the other for installation on a panel
 
 You Shall select the part to display by modifying the part variable, either in the editor or with customizer.  [1:Spool support, 2:Filament guide, 3:Extruder support, 4:All]
 
CUSTOMIZER -------------------------------
 It may help to use OpenSCAD customizer
  Customizer is experimental feature, so you need to select:
  - Menu [Edit][Preferences][Features], tick [Customizer]
  - Menu [View] Untick [Hide customizer]-
 
 You shall use the last snapshot of OpenSCAD for proper operation of Customizer.  Minimal version: Snapshot 02 January 2018.  On Mac the version 23 Dec 2017 will probably work. Some bugs on included files. 
 
 Please note that there are bugs in customizer and some options may not work, in this case you shall do direct modifications in the editor.
  
AUTHOR and Licenses ---------------------  
(c) Pierre ROUZEAU Jan 2018
files in : https://github.com/PRouzeau/Spool_support_aluminium_frame
* Part licence : CERN OHL V1.2
* Program license GPL2 & 3
* Documentation licence : CC BY-SA

DESIGN NOTES -------------------------
  The flatness of the support is to avoid the spool balancing driven by retracts that you get with simple cylindrical support
  It is slightly reclined toward the beam in order to have the spool staying always held against support flange
  Spool is slightly angled toward the support column to reduce the filament angling
  This overall design makes the friction of the spool relatively steady to avoid filament tangling without needing any braking system. 
  This is my third spool support design, the simplest and most efficient one, starting from ball bearing based system with brake to this much simpler stuff.
*/
/* [Hidden] ---------------------------- */
xpart=0; // neutralise acc display
file_beam_sec = "../Openscad/Utilities/Vslot_beam_cut.dxf";

/* [General] --------------------------- */
part=1; // [1:Spool support, 2:Filament guide, 3:Extruder support, 4:All, 5:Belt PTFE separator support]

spool_support_end = true;
spool_support_length = 80;
//arm support length, default 55 for 2040 profile, shall increase to 75 for 2020 profile 
arm_support_length = 55;
echo ("Arm support length", arm_support_length);

beam_type = 1; // [1:arm extension from profile, 3:on panel] 

angled = true;
V_slot = 0; // [0: profile with V-slot, 1:T-slot, 2: Flat panel]

// include <../../Openscad/Utilities/Vslot.scad>

if (part==1)
  spool_sup();
else if (part==2)
  filament_guide();
else if (part==3)
  extruder_sup();
else if (part==4)
  plate();
else if (part==5) //PTFE plate support:  off-topic, but shall be somewhere
  duplx(32) PTFE_sup();

//t(-10) gray() vbeam (30); // test beam

module plate () {
  spool_sup();
  t(104,-78) rotz (90) filament_guide();
  t(80,-112) rotz(70) extruder_sup();
}  

module spool_sup () {
  sup_angle = (angled)?-3:0;
diff() {
  u() {
   // support 
    rotz (sup_angle) {
      hull() {
        cubex (spool_support_length+20,30,1, 0,0,0.5);
        r(0,7) 
          dmirrory() cylx (10,spool_support_length+20, 0,15,15, 48);
        rotz (-sup_angle) 
          t(-2) r(0,10) {
            hull() {
              cubez (16,30,15, 8);  
              dmirrory(!angled) {
                cylx (10,16, 0,-15,15.5, 48);
              }  
            }
        } 
    }  
    if (spool_support_end)
      hull() {
        cubex (3,30,1, spool_support_length+20-2,0,0.5);
        r (0,7) 
          dmirrory() 
            cylx (15,3, spool_support_length+20-2,15,15, 48);
      }
  }
  // support arm
   if (beam_type<2) {
     t(-2) r(0,10) {
        hull() {
          cubez (16,30,15, 8);  
          cylx (10,16, 0,15,15.5, 48);
          cubez (8,-0.1,36.5,  4,-arm_support_length+7); 
        }  
        diff() {
          hull() {  
            cubez (8,-0.1,36.5,  4,-arm_support_length+7); 
            cubez (8,16,15,  4,-arm_support_length);  
            cylx (16,8, 0,-arm_support_length,30,48);
          }
          duplz (20)
            cylx (-4.2,22, 0,-arm_support_length,10,48);
        }
      }
    } // on profile
    else { // on wall support
      t(-2) r(0,10) 
        diff() {
          u() {
            hull() {
              dmirrory() 
                cylx (12,8, 0,14,40, 48);
              cubez (8,40,0.1, 4,0,34); 
            }
            hull() {
              cubez (8,40,0.1, 4,0,34);
              dmirrory(!angled)
                cubez (16,2,0.1, 8,-19,16);   
              cubez (12,2,0.1, 6,-19,16); 
            }
          }
          dmirrory() 
            cylx (-4,33, 0,14,40, 48);
        }
    } // on wall
  } //::::::::::::
  cubez (300,200,-20); // cut base
}
}

module filament_guide () {
  guide_width = 20;
  slot_width = (V_slot==0)?9.5:6.5;
  diff() { 
    u() {
      if (V_slot <2) rotz (-90) { // slot
        hull() { // slot insert
          cubez (0.1,slot_width,25, -0.05);
          cubez (2,5.5,25, -1);
        }  
        cubez (5.5,16,25, 5.5/2);  
      }  
      else {
        cubez (33,5.5,25, 8.5,-5.5/2);
      }
      hull() { // wire support
        cubez (8,2,8,  -4,-4.5);
        cubey (1,-guide_width,0.1,  7.5,-5);
        cubey (1,-guide_width,8, 7.5,-5,4);
        cyly (10,-guide_width, 21,-5,0, 24);
      }
      duply (-guide_width+0.5) 
        hull() {
          cubez (26,-3,7,  20,-7,0);
          cubez (18,-3,16,  16,-7,0);
        }  
    } //:::::::::::::::::::::
    duplx ((V_slot==2)?16:0) 
      cyly (-4.2,33, 0,0,16);
    cubez (300,200,-20);
  }  
}

module extruder_sup () {
  diff() {
    hull() {
      cubex (75,40,4, 2,22,2);
      cubex (55,1,4, 2,74,2);
    }
    //::::::::::::::::
    duplx (28) cylz (-4.3,33, 40,10);
    cylz (-4.3,33,10,65);
    t(46,46) rotz(30) {
      dmirrorx() dmirrory() cylz (-3.3,33, 15.5,15.5);
      cylz (-22.5,33, 0,0,0, 48);
    }  
    rotz(28) cubez (150,150,20, -45,5,-10);
  }
//Stepper and frame mockup
 *u() {
    t(46,46) rotz(30) nema17(); 
    gray() {
      t (0,10,-10) r(0,90) vbeam (100);
      t (10,20,-10) r(-90,0) vbeam (100);
    }
  }  
}

// Support for PTFE plate (for belt separation)
module PTFE_sup () {
  diff() {
    u() {
      cubey (24,32,4, 0,0,2);
      hull() {
        cubey (24,6,12, 0,0,6); 
        cubey (24,10,2, 0,0,1); 
      }  
    } 
    dmirrorx() cyly (-2.5,22, 8,0,6);  
    hull() duply (4)cylz (-4.2,22, 0,20);
  }
}


module vbeam (lg, msg="") {
  linear_extrude(height=lg, center=false)
    import (file=file_beam_sec, layer="SECTION");
  echo (str (msg," length:",lg,"mm"));
}