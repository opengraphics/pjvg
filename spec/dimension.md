# Dimensions
(draft 2)

## Level 1 (feature `dimensions-level1`)
PJVG level 1 dimensions consist of a number and a unit, or a number with no unit in the special case of 0.

Valid `<length>` units are:
- (no unit): Only valid for 0.
- `px`: Pixels in the context the image is rendered in.
- `%`: Percent of parent element's dimension.

Valid `<rotation>` units are:
- (no unit): Radians.
- `rad`: Radians.
- `deg`: Degrees.

Valid dimensions also include, some as composites:
- `position`: A 2-length array of lengths for a position.
- `size`: A 2-length array of lengths for a size.
- `point`: A 2-length array of lengths that denote a point.
- `scale`: A 2-length array of numbers that denote that the object is scaled.
- `rotation`: A number (assumed radians) or a string with units giving a rotation.
- `bounding-box`: A pair of points in a 2-length array defining a box.