#!/bin/sh

for file in *.scad
do
    part=`basename $file .scad`
    echo "--------- $part --------------"
    openscad -o "stl/$part.stl" $file
done
