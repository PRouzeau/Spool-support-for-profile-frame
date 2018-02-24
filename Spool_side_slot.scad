include <Z_library.scad>
include <X_utils.scad>

/* Spool support, filament guide and extruder plate support for 3D printers built in aluminium profiles. Option with integrated simple filament detector (switch).

INSTALLATION -------------------------------
  The spool support is adapted for spools with 50mm diameter hole. The default spool maximum width is 80mm, which is ok for 200 and 170mm diameter standard spools. This can be modified, though heavy spools may need stronger materials than PLA
    While it was designed to be installed on aluminium profile, you have also an option for installation on flat panels.
  
  The bowden extruder installation is designed for side spool installation and extruder facing you. This is the most practical setup for operation and maintenance, as I tested on the TronXY X5S which large size don't allow easy access to the back of the machine. This setup also allow to slightly shorten the Bowden tube, which is always a positive.

 By default, it is adapted for 2040 beams, bolted in the internal slot, you can extend the support arm length  (default 55 mm) if you have to install it on 2020 profile. 
 
PRINTING recommendations -------------------
 Spool support is printed in PLA with 5 top/bottom layers, 5 walls and 30% infill
 Extruder support is exposed to the stepper heat and shall be printed in a more heat resistant material, PETG or ABS.
 It is recommended to print the version with filament detector, as you may install a switch later if not interested yet. In that case, you do not need to print the filament guide, the filament being already guided.
 Depending your installation you may want to mirror parts (in your slicer). 
 You have two different shapes for the spool support, one for aluminium profile and the other for installation on a panel.
 
 You Shall select the part to display by modifying the 'part' variable (line 65), either in the editor or with customizer.  
   [0:Ensemble (for view only), 1:Spool support, 2:Filament guide, 3:extruder support plate, 4:extruder support with filament detector, 5:detector support, 6:All, 9:Belt PTFE separator support]
 
CUSTOMIZER -------------------------------
 It may help to use OpenSCAD customizer
  Customizer is experimental feature, so you need to select:
  - Menu [Edit][Preferences][Features], tick [Customizer]
  - Menu [View] Untick [Hide customizer]-
 
 You shall use the last snapshot of OpenSCAD for proper operation of Customizer.  Minimal version: Snapshot 02 January 2018.  On Mac the version 23 Dec 2017 will probably work. Some bugs on included files. 
 
 Please note that there are bugs in customizer and some options may not work, in this case you shall do direct modifications in the editor.
  
AUTHOR and Licenses ---------------------  
(c) Pierre ROUZEAU Jan-Feb 2018
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
file_beam_sec = "Vslot_beam_cut.dxf";

/* [Camera view] ------------------------ */
//Deactivate if you want to left view as it is when previewing
Force_view_position = true;
Camera_distance = 1200;
//Camera rotation vector
camVpr = [350,10,180];
//Camera translation vector
camVpt = [-70,190,60];
$vpd=Force_view_position?Camera_distance:undef;  // camera distance: work only if set outside a module
$vpr=Force_view_position?camVpr:undef; // camera rotation
$vpt=Force_view_position?camVpt:undef; //camera translation  

/* [General] --------------------------- */
part=0; // [0: ensemble, 1:Spool support, 2:Filament guide, 3:extruder support plate, 4:extruder support with filament detector, 5:detector support, 6:All, 9:Belt PTFE separator support, 99:ensemble without sensor]

spool_support_end = true;

spool_support_length = 80;

//arm support length, default 55 for 2040 profile, shall increase to 75 for 2020 profile, shall be 0 for flat panel mount 
arm_support_length = 55;
echo ("Arm support length", arm_support_length);

beam_type = 1; // [1:arm extension from profile, 3:on panel] 

angled = true;
V_slot = 0; // [0: profile with V-slot, 1:T-slot, 2: Flat panel]

if (part==1)      spool_sup();
else if (part==2) filament_guide();
else if (part==3) extruder_sup();
else if (part==4) extruder_sup(true);
else if (part==5) sw_sup();
else if (part==6) plate();
else if (part==9) //PTFE plate support to prevent belt contact: off-topic, but shall be somewhere
  duplx(32) PTFE_sup();
else if (part==99)
  ensemble(false);
else 
  ensemble();

//all parts, version with filament detector - if all parts are printed ensemble, you shall use PETG or ABS.
module plate () {
  spool_sup();
  //t(104,-78) rotz (90) filament_guide();
  t(136,-115) rotz(70) extruder_sup(true);
  t(125,0) sw_sup();
}  

//-- Spool support ---------------------------
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

//-- Filament guide ------------------------
// Not needed if using the filament detector
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

module extruder_sup (fildetect = false) {
  diff() {
    u() {
      hull() {
        cubex (70,36,4, 7,20,2);
        if (fildetect) 
          cubex (28,65,4, 0,98,2);
        else   
          cubex (50,24,4, 0,72,2);
      }
      if (fildetect) 
        t(46,46) rotz(30) 
          t(-6,22,11.5+4) {
            hull() rotz(-4){
              cubez (8,42,2, 0,38.5,-13);
              r(-3) cubez (8,42,6, 0,38.5,-3);
              // switch base      
              t(19,35+5,-12)
                cubez(20,20,5);      
            }
          }
    }  
    //::::::::::::::::
    //filament hole 
    t(46,46) rotz(30) 
      t(-6,22,11.5+4) 
        r(-3,0,-4) {
          cone3y(2,4,57.8,2,10);  
          cubez (10,26,12, 0,38,-2.5);
        // switch base      
          t(19,35+5,-7)
            cubez(29,45,10);   
       //plate screws
            duply(12) 
              cylz(-2.3,33, 24,35-1,-15);   
        }
    // profile attach holes
    duplx (25) cylz (-4.3,33, 45,10);
    duply (48) cylz (-4.3,33, 10,76);
    //motor holes
    t(46,46) rotz(30) {
      dmirrorx() dmirrory() cylz (-3.3,33, 15.5,15.5);
      cylz (-22.5,33, 0,0,0, 48);
    }  
    // bias cut
    rotz(28) cubez (150,250,20, -39,5,-10);
  }
}

//-- Global view ------------------------------
module ensemble (sensor=true) {
  // extruder support
  extruder_sup(sensor);
  //Stepper and frame mockup
  t(46,46) rotz(30) {
    nema17(); 
    //filament contact gear
    cylz (11,10, 0,0,10);
    //bearing
    silver() {
      cylz(12.5,5, -12.5,0,11.5);
      cyly(-8,20, 14,0,14);
    }  
    gray() 
      cylz(3,7, -12.5,0,11.5);
    //extruder approximation
    black() {
      cubez(44,14,18, 0,-15,4.01);
      cubez(46,15,18, 1,15,4.01);
      hull() {
        cylz(8,8, -12.5,0,4.01);
        cylz(14,8, -15,11,4.01);
      }
      hull() 
        duplx(18)
          cylz(3,18, 12,25,4.01);
      hull() {
        duplx(13)
          cylz(3,18, 12,25,4.01);
        cubez(20,5,18, 1,15,4.01);
      }  
    }  
    //bolts to motor
    gray() dmirrorx() dmirrory()
      cylz (3.3,25, 15.5,15.5);
    //filament 
    if(sensor)
      t(-6,22,11.5+4) {
          r(-3,0,-4) {
            green() cyly(2,133);
            silver() {
              //switch screws
              duply(10) 
                cylz(2,13, 13.8,35,-8);
              //plate screws
              duply(12) 
                cylz(3,15, 24,35-1,-15);
              //switch blade
              rotz(-10) 
                cubez(1,22,5, -2,35+4,-2); 
              cylz (4,5,2,29.5,-2); 
            } 
            //switch
            black()
              cubez(10,20,6,  13.8-2,35+5,-2.5); 
            //switch support
            red() t(19,35+5,-7) sw_sup();
          }  
          // filament and bowden
          green() cyly(2,-50);  
          white() cyly(4,-50, 0,-45);  
        }
  }  
  //Spool support
  green() 
    t(-2,320,-30-arm_support_length)
      rotz(10) r(0,90) r(90,90) 
        spool_sup(); 
  //aluminium profiles 
  gray() {
    t(0,10,-10)  r(0,90)   vbeam (100);
    t(10,20,-20) r(-90,90) vbeam (400,"2040 V-beam: Pylon", true, "SECTION2");
  }
  //Spool 
  t(-16,320,-arm_support_length-30)
    r(0,-87, 3) 
      spool();
}

//-- Support for filament detection switch ------
module sw_sup (){
  diff() {
    cubez(25,20,5);
    dmirrory()  {   
      cylz (-1.5,22, -5,5);
      hull() 
        duplx(-6)
        cylz(-3,22, 8,6);
    }  
  }  
}

//-- Support for PTFE plate (for belt separation)
module PTFE_sup () {
  diff() {
    u() {
      cubey(24,32,4, 0,0,2);
      hull() {
        cubey(24,6,12, 0,0,6); 
        cubey(24,10,2, 0,0,1); 
      }  
    } //:::::::::::::::::::::::
    dmirrorx() cyly(-2.5,22, 8,0,6);  
    hull() 
      duply(4)
        cylz(-4.2,22, 0,20);
  }
}

//-- Aluminium extrusions ---------------------
module vbeam (lg, msg="",center=false, profile = "SECTION") {
  linear_extrude(height=lg, center=false)
    import (file=file_beam_sec, layer=profile);
  echo (str (msg," length:",lg,"mm"));
}

//== Accessories ==========================
module spool (clr="green", spool_diam=200, spool_width=70) {
  diff() { 
    u() {
      black() { 
        cylz(spool_diam, spool_width/20,
            0,0,0,50);
        cylz(spool_diam, spool_width/20,
            0,0,spool_width*0.95,50);
      }  
      color(clr)
        cylz(spool_diam*0.92, spool_width*0.86,
            0,0,spool_width*0.07,100);
    } //::::::::::::::::::::::::::   
    cylz(-52,222); // spool hole
  }
}