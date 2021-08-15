#!/bin/sh

../combine.py main.scad  > combined.scad

for part in bottom_exposed_pins bottom_covered_pins lid_honeycomb
do
    openscad -o "stl/$part.stl" -D "cnf_part=\"$part\"" main.scad
done
