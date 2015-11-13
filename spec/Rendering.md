# PJVG Rendering Notes

All colors are defined in linear space unless denoted otherwise.

Rounding for color components is defined. If the target color format has a step size of `S`, the color should be rounded down if on `(0, S / 2)` and rounded up if on `[S / 2, 1)`. These ranges are given relative to the lower step in consideration.

Outlines on shapes must be drawn such that they do not overlap with any of the fill space on the shape. This is similar to CSS's `border-box` box-sizing model.

Shapes are defined back-to-front whenever present in lists. Rendering traversal should be depth-first.