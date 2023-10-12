//color("red")
//import ("alpakka_sane.stl");
//import ("alpakka_sane_bottom.stl");
//import ("alpakka_sane_top.stl");


q = 12;
//mirror along Y axis for comparisons
for (i = [0:1]){
    mirror([0,1,0])
//mirror along X axis for symmetric parts
    
    union(){
    
    union(){//touchpad entrance


    
    translate([49, 31, 59])
    for (f=[0:1]){ // touchpad cross
    rotate([0,0,-45+(90*f)])    
    hull(){
    translate([2.7/-2,29.5/-2,0])    
    cube([2.7,29.5,3]);
    translate([2.7/-2,2.7/-2,-17])    
    cube([2.7,2.7,2.7]);
    
        }
    }
    hull(){//basepyramidhouse for touchpad
    translate([49, 31, 40])
    cylinder(d1=1,d2=0, h=15, $fn= q/q);
        
    translate([44, 26, 40])
    cube([10,10,5]);
    }
    
    }    
    translate([49, 31, 40])
    union(){//facebuttons ABXY
    
for (r = [0:1]){
    rotate([0,0,90*r])
    for (s = [0:1]){
        mirror([s,0,0])
        translate([12,0,0])
    
    intersection(){
        
        translate([0,0,12])
        cube([12,10,24],center=true);
        union(){
            cylinder(d= 10, h= 22, $fn = q);
        hull(){
            cylinder(d= 10, h= 9, $fn = q);
        
            cylinder(d= 12, h= 7, $fn = q);
        
            }
        }
            }
    }
}
    }
    translate([0,31,40])
        union(){//playercounter
for (c = [0:1]){
    rotate([0,0,90*c])
    for (d = [0:1]){
        mirror([d,0,0])
    union(){
    
    translate([5,0,0])
    cylinder(d=2.5, h= 19, $fn= 4);
    
        translate([2,0,0])    
    hull(){
    translate([0,-2,0])    
    cube([5,4,1]);
    translate([3,0,0])
    cylinder(d=2.5, h= 15, $fn= 4);
    }
    }
    }
}
    }
                
    union(){//home button
        translate([-8,50,40])
        cube([2,4,7]);
    hull(){
        
        translate([0,52,40])
        rotate([0,0,90])
        cylinder(r = 5.77, h = 10, $fn= 6);
        
        translate([0,52,40])
        scale([1.20,1,1])
        rotate([0,0,90])
        cylinder(r = 5.77, h = 7, $fn= 6);
        }
    translate([0,52, 40])
    hull(){
        for (e=[0:1/6:1])//six sided to the home button
        translate([sin(e*360)*4.6,cos(e*360)*4.6,0])
        cylinder(d= 2, h= 21, $fn =q);
        }
    }
        translate([-49, 31, 40])
    union(){//D-PAD UDLR
for (t = [0:1]){
    rotate([0,0,90*t])
    for (u = [0:1]){
        mirror([u,0,0])
        translate([3.75,0,0])
    

        union(){
        
        hull(){
            translate([2.625,-5,0])
            cube([7,10,7]);
            color("blue")
            translate([-2.375,0,0])
            rotate([0,0,-45])
            cube([7,7,7]);
        
            hull(){
            translate([0,0,0])
            cylinder(d= 2, h= 10, $fn = q);
        
            translate([8.65,3,0])
            cylinder(d= 2, h= 10, $fn = q);
        
            translate([8.65,-3,0])
            cylinder(d= 2, h= 10, $fn = q);
        
            translate([3.5,2,0])
            cylinder(d= 4, h= 10, $fn = q);
        
            translate([3.5,-2,0])
            cylinder(d= 4, h= 10, $fn = q);
        

        
            }
            
            
            }
        hull(){
            translate([0,0,0])
            cylinder(d= 2, h= 21, $fn = q);
        
            translate([8.65,3,0])
            cylinder(d= 2, h= 21, $fn = q);
        
            translate([8.65,-3,0])
            cylinder(d= 2, h= 21, $fn = q);
        
            translate([3.5,2,0])
            cylinder(d= 4, h= 21, $fn = q);
        
            translate([3.5,-2,0])
            cylinder(d= 4, h= 21, $fn = q);
        

        
            }
            }
            


    }
}
    }
    
    
    //chip cutout, right of playercounter
    translate([9,31,40])
    cube([3,6,3]);
    // joycon doghouse
    hull(){
    translate([-37,43,40])
    cube([27,22,9]);
    translate([-29,36,40])
    cube([11,16,6]);
        //roof of the joycon doghouse! use normal measurements!
    translate([-31.7,44.3,40])
    cube([16.4,16.4,15.5]);
    }
        //joycon doghouse stick opening
    translate([-23.5,52.5,55.5])
    cylinder(d1 = 16.5 , r2 = 10.25 , h = 5.5, $fn=q);
    union(){//scroll wheel doghouse
    
    
    hull(){//left side of scroll wheel doghouse
    
    translate([7,44.5,40])
    cube([9,14,11]);
    
    translate([7,46.5,40])
    cube([9,10,13]);
    }
    
    hull(){//right side of scroll wheel doghouse
    
    translate([24,45,40])
    cube([18,14,13.5]);
    
    translate([24,47,40])
    cube([18,10,15.5]);
    }
    
    
    translate([35, 52, 40])
    hull(){ //right side 8 directional stick
    
    translate([4,4,0])
        
        cylinder(d=2, h = 21, $fn = q);
        
    translate([-4,4,0])
        cylinder(d=2, h = 21, $fn = q);
        
    translate([4,-4,0])
        cylinder(d=2, h = 21, $fn = q);
        
    translate([-4,-4,0])
        cylinder(d=2, h = 21, $fn = q);
        }
    hull(){
    translate([20,51.5,54])
    hull(){
    translate([3,11.5,0])
    rotate([180])
    cylinder(r=1, h= 14,$fn =q );
        
    translate([-3,11.5,0])
    rotate([180])
    cylinder(r=1, h= 14,$fn =q );
        
    translate([3,-11.5,0])
    rotate([180])
    cylinder(r=1, h= 14,$fn =q );
        
    translate([-3,-11.5,0])
    rotate([180])
    cylinder(r=1, h= 14,$fn =q );
    }
    translate([20,51.5,54])
    hull(){//scrollwheel void itself
    
    for (n = [0:1]){
        mirror([n,0,0])
        for (o = [0:1/24:1]){// o = 0-> 1/number of steps->1,  the number of steps is important. This step, at ~250 lines written, including whitespace, is extremely intensive.
            echo(o)
            translate([3, cos((o)*360)*11.5,sin((o)*360)*11.5])
            sphere(1, $fn = q/2);
            
            
            
            
            }
        }
    }
}
}
for (j = [0:1]){
    mirror([j,0,0])
{
    union() 
    {
// true mirror objects
        
        //front charger opening    
        hull(){   
        translate([0,9,37])
        
        cube([7,14,9]);
        
        translate([0,9,34])
        
        cube([4,14,9]);
        
        }
        //anchors
        
        intersection(){
        
        translate([59,78,40])
        cube([10,10,5]);
        
            
        
        hull(){
        translate([59,79,40])
        cube([8,7,5]);

        translate([60,78,40])
        cube([6,7,5]);
        
        
        translate([59,82,35])
        cube([8,7,5]);
        }
        }
        //mysterious chip squares
        union(){
        translate([44,50,40])
        cube([10,9,3]);
        translate([55,52,40])
        cube([9,10,3]);
        }
        //bumper doghouse
        union(){
        translate([34,17,40])
        cube([9,8,9]);
        hull(){
        translate([39,10,40])
        cube([4,7,9.5]);
        
        translate([28,12,40])
        cube([3,5,9.5]);
        }
        translate([28, 14, 46.5])
        cylinder(h = 13, d = 6,  center= true, $fn = q);
        }
        //bumper entrance
         
        color("blue")

        hull(){

 
        translate([39,7,40])
        cube([7,3,9.5]);
        
        translate([51,7,40])
        cube([7,5,9.5]);
        translate([45,7,40])
        cube([7,5,13]);
          
        }

        //extra bumper swingarm space
        hull(){
        translate([39,7,40])
        cube([7,5,9.5]);
        color("green")
        translate([39,7,40])
        cube([4,8,9.5]);
        }
        hull(){
        translate([43,10,49.5])
        rotate([270,0,0])
        cylinder(d1 = 1 , r2 = 0, h = 5,$fn = q);
        translate([44,10,49.5])
        rotate([0,270,0])
        cylinder(d1 = 1 , r2 = 0, h = 5,$fn = q);
        translate([45,12,48])
        rotate([0,0,0])
        cylinder(d1 = 1 , r2 = 0, h = 5,$fn = q);
        translate([45,12,49.5])
        rotate([0,90,0])
        cylinder(d1 = 1 , r2 = 0, h = 1,$fn = q);
        }
        // foursquare facebuttons
        union(){
        //top buttons
        hull(){
        
        translate([15,15,40])
        cube([10,8,7]);
        
        translate([20, 19, 49])
        for (l = [0:1]){
        for (k = [0:1]){
        mirror([k,l,0])
            translate([3,3,0])
            sphere(1, $fn = q);
            }
            }
        }
        
        hull(){
        
        translate([20, 19, 49])
        for (l = [0:1]){
        for (k = [0:1]){
        mirror([k,l,0])
            translate([3,3,0])
            sphere(1, $fn = q);
            }
            }
        
        translate([20, 19, 59])
        for (l = [0:1]){
        for (k = [0:1]){
        mirror([k,l,0])
            translate([3,3,0])
            sphere(1, $fn = q);
            }
            }
        }
        //bottom buttons
        hull(){
        
        translate([15,27,40])
        cube([10,8,7]);
        
        translate([20, 31, 49])
        for (l = [0:1]){
        for (k = [0:1]){
        mirror([k,l,0])
            translate([3,3,0])
            sphere(1, $fn = q);
            }
            }
        }
        
        hull(){
        
        translate([20, 31, 49])
        for (l = [0:1]){
        for (k = [0:1]){
        mirror([k,l,0])
            translate([3,3,0])
            sphere(1, $fn = q);
            }
            }
        
        translate([20, 31, 59])
        for (l = [0:1]){
        for (k = [0:1]){
        mirror([k,l,0])
            translate([3,3,0])
            sphere(1, $fn = q);
            }
            }
        }
        }

    }
    //front hex attach
    
    hull(){
    translate([ 20, 11.5, 44.5])
    cylinder(r=3, h = 3, $fn = 6);
    
    translate([ 20, 5, 44.5])
    cylinder(r=3, h = 3, $fn = 6);
    }
    
    
    translate([ 20, 11.5, 44.5])
    rotate([180, 0 ,0])
    cylinder(d= 2.5, h = 9.5, $fn = q);
}
}
}
}
