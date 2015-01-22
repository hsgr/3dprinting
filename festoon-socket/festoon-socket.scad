/*
  Festoon LED socket design
  Copyright (C) 2013 Vasilis Tsiligiannis <acinonyx@openwrt.gr>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  Also add information on how to contact you by electronic and paper mail.
*/

$fn = 150;
accuracy = .01;

// LED parameters
bulb_width = 39;
bulb_diameter = 12;

// Spacer parameters
spacer_height = 7.45;
spacer_width = 4;
spacer_m = 3;
spacer_hole = 1;

// Stand parameters
stand_thick = 4;
stand_height = spacer_width + 4;
stand_width = spacer_width + stand_thick * 2;
stand_hole_m = spacer_m + 0.2;
stand_hole_pos = stand_height - 2 - spacer_width / 2;

// Base parameters
base_hole_m = 7;
base_hole_thick = 5;
base_length = bulb_width - 1 + (stand_height + stand_thick) * 2;
base_width = bulb_diameter;
base_thick = 5;

// Do not edit bellow

base (base_length,
      base_width,
      base_thick,
      base_hole_m,
      base_hole_thick,
      stand_width,
      stand_height,
      stand_thick,
      stand_hole_m,
      stand_hole_pos);

module spacer (width, height, m, hole) {
    difference () {
        cube ([width, width, height]);
        translate ([width / 2, width / 2, 0])
            cylinder (h = height, r = m / 2);
        translate ([width / 2, 0, height * 2 / 3])
            rotate ([-90, 0, 0])
	    cylinder (h = width, r = hole / 2);
    }
}

module stand_sup (width, height, thick) {
    translate ([0, thick, 0])
        rotate ([90, 0, 0])
	ortho_triangle (thick, width, height);
}

module stand (width, height, thick, hole_m, hole_pos) {
    difference () {
	union () {
	    cube ([width, thick, height]);

	    translate ([thick, thick - accuracy, -accuracy])
		rotate ([0, 0, 90])
                stand_sup (height, height, thick);
	    translate ([width, thick - accuracy, -accuracy])
		rotate ([0, 0, 90])
                stand_sup (height, height, thick);
		
	}
	translate ([width / 2, -thick / 2, hole_pos])
	    teardrop (thick * 2, hole_m / 2);
    }
}

module teardrop (height, radius) {
    rotate ([-90, 0, 0])
        union () {
	cylinder (h = height, r = radius);
	rotate ([0, 0, -135])
            cube ([radius, radius, height]);
    }
}
    
module base (length,
             width,
	     thick,
	     hole_m,
	     hole_thick,
             stand_width,
	     stand_height,
	     stand_thick,
	     stand_hole_m,
	     stand_hole_pos
    ) {

    union () {
        cube ([length, width, thick]);
        translate ([length - stand_height - stand_thick, stand_width / 2 + width / 2, thick])
            rotate ([0, 0, -90])
	    stand (stand_width, stand_height, stand_thick, stand_hole_m, stand_hole_pos);
        translate ([stand_height + stand_thick, -stand_width / 2 + width / 2, thick])
            rotate ([0, 0, 90])
	    stand (stand_width, stand_height, stand_thick, stand_hole_m, stand_hole_pos);
        translate ([0, width, 0])
	    rotate ([0, 0, -135])
	    translate ([-length / sqrt(2), 0, 0])
	    difference () {
	    union () {
		difference () {
		    ortho_triangle (thick, length / sqrt(2), length / sqrt(2));
		    translate ([0, 0, -thick / 2])
			fillet (thick * 2, hole_thick + hole_m / 2);
		    rotate ([0, 0, -135])
			translate ([-length / 2, hole_thick / 2, -thick / 2])
			ortho_triangle (thick * 2, length / 2 - hole_thick / 2 - sqrt(2) * hole_thick, length / 2 - hole_thick / 2 - sqrt(2) * hole_thick);
		    rotate ([0, 0, 135])
			translate ([hole_thick / 2, -length / 2, -thick / 2])
			ortho_triangle (thick * 2, length / 2 - hole_thick / 2 - sqrt(2) * hole_thick, length / 2 - hole_thick / 2 - sqrt(2) * hole_thick);
		}
		translate ([hole_thick + hole_m / 2, hole_thick + hole_m / 2, 0])
		    cylinder (h = thick, r = hole_thick + hole_m / 2);
	    }
	    translate ([hole_thick + hole_m / 2, hole_thick + hole_m / 2, -thick / 2])
		cylinder (h = thick * 2, r = hole_m / 2);
	}

    }

}

module fillet (height, r) {
    difference () {
        translate ([-accuracy, -accuracy, 0])
            cube ([r + accuracy, r + accuracy, height]);
        translate ([r, r, -height / 2])
            cylinder (h = height * 2, r = r);
    }
}

module ortho_triangle (h, x, y) {
    polyhedron (points = [[0, 0, 0], [ 0, y, 0], [ x, 0, 0],
                          [0, 0, h], [ 0, y, h], [ x, 0, h]],
                triangles = [[0, 2, 1], [3, 4, 5],
                             [0, 5, 2], [5, 0, 3],
                             [0, 1, 3], [3, 1, 4],
                             [1, 2, 5], [1, 5, 4]]);
}