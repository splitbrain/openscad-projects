#!/bin/sh

for part in camera lid post arm all
do
    openscad -o "stl/$part.stl" -D "cnf_part=\"$part\"" main.scad
done
