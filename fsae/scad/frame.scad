color("red"){
   translate([0, -250, 50]) sphere(r=25);
   translate([0, 250, 50]) sphere(r=25);
   translate([0, -180, 1150]) sphere(r=25);
   translate([0, 180, 1150]) sphere(r=25);
   translate([600, -250, 50]) sphere(r=25);
   translate([600, 250, 50]) sphere(r=25);
   translate([600, -200, 650]) sphere(r=25);
   translate([600, 200, 650]) sphere(r=25);
   translate([1500, -150, 50]) sphere(r=25);
   translate([1500, 150, 50]) sphere(r=25);
   translate([1500, -150, 300]) sphere(r=25);
   translate([1500, 150, 300]) sphere(r=25);
   translate([300, -300, 325]) sphere(r=25);
   translate([300, 300, 325]) sphere(r=25);
   translate([-500, -200, 500]) sphere(r=25);
   translate([-500, 200, 500]) sphere(r=25);
   translate([-500, 250, 50]) sphere(r=25);
   translate([-500, -250, 50]) sphere(r=25);
}

color("yellow"){
	hull(){
		translate([0, -250, 50]) sphere(r=20);
		translate([0, 250, 50]) sphere(r=20);
	}
}