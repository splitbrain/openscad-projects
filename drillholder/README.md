# Customizable Drill Bit Holder

This project creates wall mountable drill bit holders.

The goal was to be able to quickly define the bit sizes to be stored and have a model created that is relatively quick to print.

To customize, simply configure the `set` matrix at the top of the file. Each line describes a single bit to be held by three parameters:

1. The shaft width (in mm). An appropriate hole (with added tolerance) will be created
2. The tool head width (in mm). This defaults to the shaft width when set to 0 or omitted. This is useful where the tool head is wider than the shaft. Like for forstner bits.
3. The depth of the holder (in mm). Eg. how deep the bit will be inserted into the holder. Defaults to 30mm.

You can tweak some additional parameters but it shouldn't be needed. Screw holes are automatically added after the first and before the last bit.

Printed with 0.3mm layer height, a holder for a typical small set of bits prints in about an hour.
