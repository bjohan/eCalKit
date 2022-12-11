module x(d){
    translate([d,0,0]) children();
}

module y(d){
    translate([0,d,0]) children();
}

module z(d){
    translate([0,0,d]) children();
}



module centerCube(v){
    translate([-v[0]/2,-v[1]/2,0]) cube(v);
}

module quad(x, y){
    x2=x/2;
    y2=y/2;
    translate([x2, y2, 0]) children();
    translate([x2, -y2, 0]) children();
    translate([-x2, y2, 0]) children();
    translate([-x2, -y2, 0]) children();
}

module rectPlace(v){
    translate([-v[0]/2,-v[1]/2,0]) children();
    translate([-v[0]/2,v[1]/2,0]) children();
    translate([v[0]/2,-v[1]/2,0]) children();
    translate([v[0]/2,v[1]/2,0]) children();
}


module nObj(r, n, offs){
    for(a=[1:n]) rotate([0,0, offs+a*360/n]) translate([r,0,0]) children();
}

module quadobj(d){
    nObj(sqrt(2)*d, 4, 45) children();
}

module quad(x, y){
    x2=x/2;
    y2=y/2;
    translate([x2, y2, 0]) children();
    translate([x2, -y2, 0]) children();
    translate([-x2, y2, 0]) children();
    translate([-x2, -y2, 0]) children();
}

module linplace(p1, p2, n, skipStart=0, skipEnd=0, offs=0){
    delta=(p2-p1)/(n-1);
    for(i=[skipStart:n-skipEnd-1]){
        translate(p1+delta*i+delta*offs) children();
    }
}

module smaConnector(){
    color([1,0,0])cylinder(8, 6.5/2, 6.5/2);
    centerCube([16, 6, 3.5]);
}

module sp6tHolePattern(l=10){
translate([0,0,42.5+5-l])quadobj(35/2) cylinder(l, 3/2, 3/2);
}
module sp6t(){
    cylinder(42.5, 20.5, 20.5);
    translate([0,0,-9])
    cylinder(9, 11.1, 11.1);
    translate([0,0,42.5]){
        difference(){
            intersection(){
                centerCube([45, 45,3]);
                cylinder(3, 57/2, 57/2, $fn=100);
            }
        translate([0,0,-42.5+5])sp6tHolePattern();
        }
        translate([0,0,3]){
            color([0,1,0])nObj(13, 6, 0) cylinder(8, 6.5/2, 6.5/2);
            cylinder(8, 6.5/2, 6.5/2);
        }
    }
}

module placeRelays(){
    translate([24,0,0]) children();
    translate([-24,0,0]) children();
}

module smaBulkHead(){
    tol=0.35;
    nr=4.0/cos(30)+tol;
    cylinder(15,3.1+tol,3.1+tol);
    rotate([0,0,30])cylinder(4,nr,nr, $fn=6);
}        

l=110;
w=50;
t=6;
h=80;
hbot=40;

module relayMountBody(){
    centerCube([l, w, t]);
}

module placeRelayMount(p=1){
    translate(p*[0,0,39])children();
}

module relayMount(){
    difference(){
        placeRelayMount() relayMountBody();
        placeRelays(){ 
            minkowski(){
                sp6t();
                sphere(0.25);
            }
            sp6tHolePattern();
        }
        screws();
    }
}

module wallBody(){
    centerCube([t,w,h+hbot]);
}

module wall(){
    wallBody();
}

module placeWalls(a=true, b=true){
    if(a) translate([l/2+t/2,0,-hbot]) children();
    if(b) translate([-l/2-t/2,0,-hbot]) children();
}

module walls(a=true, b=true){
    difference(){
        placeWalls(a=a, b=b)wall();
        screws();
    }
    
}

module topBody(){
    difference(){
        translate([0, 0,h-t/2])centerCube([l+t*2,w,t]);
        minkowski(){
            placeWalls() wall();
            sphere(0.25);
        }
    }
}

module placeSmaConnectors(){
      translate([24, -w/4,h-t/2-0.1]) children();
        translate([-24, w/4,h-t/2-0.1]) children();
        
        translate([-w/4+24, w/4,h-t/2-0.1]) children();
        translate([-w/4+ -24, -w/4,h-t/2-0.1]) children();
        
        translate([w/4+24, w/4,h-t/2-0.1]) children();
        translate([w/4+ -24, -w/4,h-t/2-0.1]) children();
}

module top(){
    difference(){
        topBody();
        screws(r=1.75, $fn=15);
        placeSmaConnectors() smaBulkHead();
        /*translate([24, -w/4,h-t/2-0.1]) smaBulkHead();
        translate([-24, w/4,h-t/2-0.1]) smaBulkHead();
        
        translate([-w/4+24, w/4,h-t/2-0.1]) smaBulkHead();
        translate([-w/4+ -24, -w/4,h-t/2-0.1]) smaBulkHead();
        
        translate([w/4+24, w/4,h-t/2-0.1]) smaBulkHead();
        translate([w/4+ -24, -w/4,h-t/2-0.1]) smaBulkHead();*/
    }
    //translate([0, 0,h-t/2-0.1]) smaBulkHead();
}

module bottomBody(){
    difference(){
        translate([0, 0,-hbot-t/2])centerCube([l+t*2,w,t]);
        minkowski(){
            placeWalls() wall();
            sphere(0.25);
        }
    }
}

module bottom(){
    difference(){
        bottomBody();
        screws();
        translate([-45,20,-100])cylinder(200,6,6);
    }
    
}


module screw(r=1.5){
    z(-10)cylinder(30, r, r);
}

module placeScrewStrip(){
    linplace([0, -w/2+t, 0], [0, w/2-t ,0], 4) children();
}

module placeScrewStripsHalf(){
    translate([-(l+t)/2,0,-hbot-t]) children();
    translate([-(l+t)/2,0,h-20+t]) children();
    translate([-(l+t)/2-t,0,39+t/2]) rotate([0,90,0])children();
}

module placeScrews(){
    placeScrewStripsHalf() children();
    mirror([1,0,0])placeScrewStripsHalf() children();
}
module screws(r=1.5){
    placeScrews() placeScrewStrip() screw(r=r);
}


module placeUsbHolePattern(){
    d=27.3/2;
    x(d) children();
    x(-d) children();
}

module usbBody(){
    centerCube([20.5+0.5,14.2+0.5,25]);
    centerCube([12,10.6,25+3]);
    z(20) hull() quad(24.5, 0) cylinder(5, 6,6);
    z(-5) cylinder(5, 9.4/2, 9.4/2);
}

module usb(){
    difference(){
        usbBody();
        placeUsbHolePattern() cylinder(30, 2,2);
    }
}

module banana(){
    cylinder(4,6,6);
    z(-22)cylinder(22, 4,4);
    x(4)z(-1) cylinder(1,1,1, $fn=20);
}


module alubox(){
    dx=90;
    dy=31;
    dz=30;
    centerCube([dx, dy , dz]);
}


module frameAssembly(compartment=true){
    walls();
    top();
    bottom();
    relayMount();
    bottomBox(compartment=compartment); 
}   
module assembly(compartment=true){
    placeRelays()sp6t();
    placeSmaConnectors() smaBulkHead();
    z(-3) bottomComponents(); 
    frameAssembly(compartment=compartment);
    bottomLid();
    topLid();
}

module bottomComponents(){
    z(-73){
        translate([0,-0.5,0]){
            y(8)x(-5)alubox();
            translate([-2, 0, -3]){
                y(-15)x(36)rotate([0,0,0])z(20)rotate([180,0,0]){
                    usb();
                    placeUsbHolePattern() cylinder(30, 1.5,1.5);
                }
                y(-1){
                    x(48)rotate([180,0,0])banana();
                    y(19)x(48)rotate([180,0,0])banana();
                }
            }
        }
    }
}

module bottomBoxBody(compartment=true){
    difference(){
        union(){
            difference(){
                intersection(){
                    z(-3) translate([0, 0,-hbot-t/2]) centerCube([l+t*2,w,3]);
                    z(-2.75) bottom();
                }
                z(-3) translate([0, 0,-hbot-t/2]) centerCube([l+t*2*0-8,w-4,3]);
            }
            if(compartment) z(-3-33) translate([0, 0,-hbot-t/2]) centerCube([l+t*2*0-8+3*2,w,34]);
        }
        z(-3-30) translate([0, 0,-hbot-t/2]) centerCube([l+t*2*0-8,w-4,34]);
    }
}

module bottomBox(compartment=true){
    difference(){
        bottomBoxBody(compartment=compartment);
       z(-3) bottomComponents(); 
    }
}

module bottomLid(){
    difference(){
        ev=[5,5,5];
        intersection(){
            minkowski(){
                hull() frameAssembly(compartment=false);
                translate(-ev/2)cube(ev);
            }
            y(29.5-3)z(-100)centerCube([200,21,200]);
        }
        
        minkowski(){
            union(){
                hull() frameAssembly(compartment=false);
                frameAssembly(compartment=true);
            }
            sphere(0.35);
        }
        screws($fn=10);
        placeSmaConnectors() cylinder(20,5,5);
        
        z(-3-33) translate([0, 0,-hbot-t/2]) centerCube([l+t*2*0-8+3*2,w,34]);
    }
}

module topLid(){
    difference(){
        ev=[5,5,5];
        intersection(){
            minkowski(){
                hull() frameAssembly(compartment=false);
                translate(-ev/2)cube(ev);
            }
            y(-(29.5-3))z(-100)centerCube([200,21,200]);
        }
        
        minkowski(){
            union(){
                hull() frameAssembly(compartment=false);
                frameAssembly(compartment=true);
            }
            sphere(0.35);
        }
        screws($fn=10);
        placeSmaConnectors() cylinder(20,5,5);
        
        z(-3-33) translate([0, 0,-hbot-t/2]) centerCube([l+t*2*0-8+3*2,w,34]);
    }
}
assembly();
//bottomLid();
//topLid();
//frameAssembly(compartment=true);
//bottomBox();
//bottom();

//banana();

//top();
//frameAssembly(compartment=true);
//screws();
//bottom();


//translate([0,0,-2])smaBulkHead();