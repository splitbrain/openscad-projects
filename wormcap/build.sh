#!/bin/sh

for part in lid ring all
do
    openscad -o "stl/$part.stl" -D "cnf_part=\"$part\"" main.scad
done
