/**
 * @link http://forum.openscad.org/Beginner-Honeycomb-advice-needed-td4556.html
 * @author Przemo Firszt
 */

module honeycomb_column(length, cell_size, wall_thickness)
{
    no_of_cells = floor(length / (cell_size + wall_thickness));

    for (i = [0:no_of_cells]) {
        translate([ 0, (i * (cell_size + wall_thickness)), 0 ])
            circle($fn = 6, r = cell_size * (sqrt(3) / 3));
    }
}

module honeycomb(length, width, height, cell_size, wall_thickness)
{
    no_of_rows = floor(1.2 * length / (cell_size + wall_thickness));

    tr_mod = cell_size + wall_thickness;
    tr_x = sqrt(3) / 2 * tr_mod;
    tr_y = tr_mod / 2;
    off_x = -1 * wall_thickness / 2;
    off_y = wall_thickness / 2;
    linear_extrude(
        height = height, center = true, convexity = 10, twist = 0, slices = 1)
        difference()
    {
        square([ length, width ]);
        for (i = [0:no_of_rows]) {
            translate([ i * tr_x + off_x, (i % 2) * tr_y + off_y, 0 ])
                honeycomb_column(width, cell_size, wall_thickness);
        }
    }
}

module choneycomb(v, size, walls) {
    translate([v.x/-2, v.y/-2, v.z/2]) {
        honeycomb(v.x, v.y, v.z, size, walls);
    }
}
