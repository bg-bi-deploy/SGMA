M107
M190 S50 ; set bed temperature and wait for it to be reached ok
M109 S180 ; set temperature and wait
M107 ;turn off fan
G21 ; set units to millimeters
G90 ; use absolute coordinates
M82 ; use absolute distances for extrusion
G0 X0 Y0 F9000 ; Go to front
G0 Z0.35 ; Drop to bed
G92 E0 ; zero the extruded length
G1 E180.01 Y200  F500
G1 E180.02 X200  F500 ; Extrude 25mm of filament in a 4cm
G1 E180.01 Y0    F500
G1 E180.03 X0    F500
