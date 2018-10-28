#!/usr/bin/python
"""
    Simple python script to create a single combined .scad file from a given
    input .scad file that uses 'include' and 'use'. This is very very simple.
    It is assumed, that files that are referenced by 'use' do not have any
    side effects, eg. only declare modules. They are only included once.
"""

import sys
import re
import os

USES = []


def readFile(scad):
    """
        Reads the given .scad file and includes all found uses and imports

        :param scad: The input .scad file
    """
    scad = os.path.abspath(scad)
    cwd = os.path.dirname(scad)
    lines = ["/* START " + os.path.basename(scad) + "*/\n"]

    with open(scad) as fp:
        for line in fp:
            os.chdir(
                cwd
            )  # always work within the file's directory
            m = re.match("(use|include) <(.*?)>", line)
            if m:
                (t, f) = m.groups()

                # include uses only once
                if t == "use":
                    if f in USES:
                        continue
                    USES.append(f)

                lines.extend(readFile(f))
            else:
                lines.append(line)

    lines.append(
        "/* END " + os.path.basename(scad) + "*/\n"
    )
    return lines


def main():
    if len(sys.argv) < 2:
        print("Usage: " + sys.argv[0] + " input.scad")
        sys.exit(1)

    all = readFile(sys.argv[1])
    print("".join(all))


if __name__ == "__main__":
    main()
