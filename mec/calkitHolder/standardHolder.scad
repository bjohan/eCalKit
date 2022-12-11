module z(d){
    translate([0,0,d]) children();
}

module cCube(v){
    x=v[0]/2;
    y=v[1]/2;
    translate([-x, -y, 0]) cube(v);
    
}

module smaHex(l, n=6, wrenchClearance=false, isRound=false){
    r=(4.0-0.0)/cos(30);
    if(isRound)
        if (wrenchClearance){
            cylinder(l,r+12,r+12);
        } else {
            cylinder(l,r,r);
        }
    else{
        if(wrenchClearance){
            cylinder(l,r+12,r+12, $fn=n);
        }else{
            cylinder(l,r,r, $fn=n);
        }
    }
}

module smaTerm(tl=16, isRound=false, wrenchClearance=false){
    translate([0,0,2])smaHex(6, isRound=isRound, wrenchClearance=wrenchClearance);
    z(-1)cylinder(tl, 4,4);
}

module smaBullit(wrenchClearance=false, isRound=true){
    r=6.3/2;
    cylinder(22.2, r, r);
    r2=9.5/cos(30)/2;
    translate([0,0,6]) cylinder(1.6,r2,r2, $fn=6);
    if(isRound){
        translate([0,0,22.2-1.6-6]) smaHex(1.5, n=18); 
    } else {
        translate([0,0,22.2-1.6-6]) smaHex(1.5); 
    }
    if(wrenchClearance)translate([0,0,22.2-1.6-6]) cylinder(2,9,9+2); 
}


module smaBarrelHalf(isRound=false, wrenchClearance=false ){
    r=6.3/2;
    z(-11){
        cylinder(22/2, r, r);
        if(isRound)
            smaTerm(tl=4,$fn=24, isRound=true, wrenchClearance=wrenchClearance);
        else
            smaTerm(tl=4,wrenchClearance=wrenchClearance);
    }
}

module smaBarrel(wrenchClearance=false, isRound=false){
    z(11){
        smaBarrelHalf(isRound=isRound, wrenchClearance=wrenchClearance);
        mirror([0,0,1])smaBarrelHalf(isRound=isRound, wrenchClearance=wrenchClearance);
    }
}


//translate([0,0,-11.1])smaBullit();
//smaTerm();


module termHolderBody(isRound=false){
    l=20+5;
    if(isRound){
        r=6.3/cos(30);
        translate([0,0,2]) cylinder(l, r,r,$fn=24);
    } else {
        r=6.3/cos(30);
        translate([0,0,2]) cylinder(l, r,r,$fn=6);
    }
}

module termHolder(isRound=false){
    difference(){
        termHolderBody(isRound=isRound);
        smaTerm();
        translate([0,0,16])screw(th=true);
    }
}


module placeSmaBullit(){
    translate([0,0,-11.1]) children();
}

//termHolder();
//kanske 3/4" fattning på snurrmojj så man kan lossa med n-nyckel

module placeTerms(l=42){
    rotate([0,0,0]) translate([l,0,0])rotate([0,-90,0]) children();
    rotate([0,0,120]) translate([l,0,0])rotate([0,-90,0]) children();
    rotate([0,0,-120]) translate([l,0,0])rotate([0,-90,0]) children();
}


module screw(th=false){
    if(th) translate([0,0,-30]) cylinder(30, 3.5, 3.5); 
    cylinder(3,3,3);
    cylinder(22,1.5,1.5);
}

module termAssembly(isRound=false){
    termHolder(isRound=isRound);
    smaTerm();
    translate([0,0,16])screw();
}

module mainBodyBody(){
    r=5/cos(45);
    hull () placeTerms(l=15)  rotate([0,0,45]) cylinder(2,r,r, $fn=4);
}

module mainBody(){
    difference(){
        mainBodyBody();
        placeTerms() termAssembly();
        minkowski(){
            placeSmaBullit() smaBullit(wrenchClearance=true);
            sphere(0.25);
        }
    }
}

module mainBodyBody2(){
    r=5/cos(45);
    hull () placeTerms(l=15)  rotate([0,0,45]) cylinder(2,r,r, $fn=4);
}

module mainBody2(){
    difference(){
        mainBodyBody2();
        placeTerms() termAssembly();
        minkowski(){
            placeSmaBullit() smaBarrel(wrenchClearance=true, isRound=true);
            
            sphere(0.25);
        }
        z(-50) smaHex(100);
    }
}



module marking(text){
    linear_extrude(height = 3) text(text = text, size = 6, valign = "center", halign="center");
}

module termHolderMarking(text){
        for(i=[0:5]){   
            rotate([0,0,60*i])translate([0,-6,20])rotate([90,0,0]) marking(text);
    }
}

/*module assembly(isRound=false){
    placeTerms()termAssembly(isRound=isRound);
    placeSmaBullit() smaBullit(isRound=isRound);
    mainBody();
}*/

module assembly(isRound=false){
    placeTerms()termAssembly(isRound=isRound);
    placeSmaBullit() smaBarrel(isRound=isRound);
    turner(isRound=isRound);
    mirror([0,0,1])turner(isRound=isRound);
    mainBody2();
}



module loadHolder(){
    difference(){
        termHolder();
        termHolderMarking("L");
    }
}

module shortHolder(){
    difference(){
        termHolder();
        termHolderMarking("S");
    }
}

module openHolder(){
    difference(){
        termHolder();
        termHolderMarking("O");
    }
}



module caseBody(tr=2, or=2){
    //r = 2;
    intersection(){
        minkowski(){
            assembly(isRound=true);
            z(-15) cylinder(30,or,or);
        }
        v = [100,100,22+2*tr];
        #translate(-v/2) cube(v);
    }
}

module topCaseA(){
    difference(){
        caseBody(or=2);
        z(-200-1.5) cCube([200,200,200]);
        minkowski(){
            assembly();
            sphere(0.6);
        }
    }
}



module bottomCase(){
    /*module assembly(isRound=false){
        placeTerms()termAssembly(isRound=isRound);
        placeSmaBullit() smaBullit(isRound=isRound);
        mainBody();
    }*/

    difference(){
        caseBody(or=4);
        z(1.5) cCube([200,200,200]);
        minkowski(){
            assembly(isRound=true);
            sphere(0.6);
            cylinder(100,0.6, 0.6);
        }
        minkowski(){
            topCaseA();
            sphere(0.6);
        }
    }
}

module topCase(){
    difference(){
        caseBody(or=4 );
        z(-200-1.5) cCube([200,200,200]);
        minkowski(){
            assembly(isRound=true);
            sphere(0.6);
            rotate([180,0,0])cylinder(100,0.6, 0.6);
        }
        minkowski(){
            bottomCase();
            sphere(0.6);
        }
    }
}

module knurCylinder(l, ro, rk, nk){
    cylinder(l, ro-rk, ro-rk);
    for(i=[0:nk-1]){
        rotate([0,0,i*(360/nk)])translate([ro-rk, 0,0]) cylinder(l,rk,rk);
    }
}


module turner(isRound=false){
    r=14.5;
    difference(){
        z(-6){
            if(isRound) cylinder(3, r, r);
            else knurCylinder(3, r, 1, 52);
        }
        smaBarrelHalf();
    }
}

//mainBody();
//mainBody2();


//smaBullit();
//smaBarrel(isRound=true);
assembly(isRound=false);
//z(20)topCase();
//z(-20) bottomCase();
//bottomCase();
z(50) topCase();
z(-50) bottomCase();
//loadHolder();
//shortHolder();
//openHolder();
//mainBody2();
//loadHolder();
//turner();
//termHolder();
//termAssembly();
//placeTerms()termAssembly();
//translate([0,0,-11.1])smaBullit();

//hull(){
//placeTerms()smaTerm();
//}

