# Shapes
(draft 3)

Shapes in PJVG denote anything that can be drawn. They have an object type of "shape".

## Level 1 (feature `shapes-level1`)
Level 1 PJVG shapes:
- `polygon`: A list of points forming a closed polygon.
- `fill`: A shape that fills completely. Used with clipping masks to fill arbitrary shapes.
- `rectangle`: A polygon with four points and extra flow features.
- `ellipse`: A polygon with renderer-defined segments.
- `operator`: An operator on one or more shapes.

### Shape
All shapes can have the following fields:
- `position = [0, 0]` (`<position>`): The position of the shape relative to its parent.
- `scale = [1, 1]` (`<scale>`): The scale the object should be drawn at.
- `rotation = 0` (`<rotation>`): The rotation of the object.
- `rotationOffset = ["50%", "50%"]` (`<point>`): A point relative to the upper-left corner to rotate around.
- `clip = null` (`null|<bounding-box>|[<shape>]|"parent"`): Defines a clipping area for this shape.
	- `null`: No clipping will be performed.
	- `<bounding-box>`: Clipping will be performed within the bounding box.
	- `[<shape>]`: Clipping will be performed using a list of shapes as a mask.
	- `"parent"`: Clipping will occur using the parent element as a mask.
- `children = []` (`array`): An array of children that this object has.

### Polygon (feature `polygon-level1`)
- `points = []` (`array`): A list of points that the polygon has relative to its position.
- `fill = false` (`bool`): Whether the polygon should be filled.
- `outline = false` (`bool`): Whether the polygon should be outlined.
- `fillColor = "#ffffff"` (`<color>`): The color to fill with.
- `outlineColor = "#ffffff"` (`<color>`): The color to outline with.
- `outlineWidth = "1px"` (`<length>`): How thick outlines should be.
- `outlineStyle = "solid"` (`<line-style>`): The style of the outline lines.

### Fill (feature `fill-level1`)
- `fillStyle = "solid"` (`"solid"`): How to fill.

For `"solid"` fills:
- `fillColor = "#ffffff"`: The color to fill with.

### Rectangle (feature `rectangle-level1`)
- `size = [0, 0]` (`<size>`): The size of the rectangle.
- `fill = false` (`bool`): Whether the polygon should be filled.
- `borderRadius = null` (`null|<length>|[<length>,<length>,<length>,<length>]`): The border radius of the rectangle.
	- `null`: No rounding on the edges.
	- `<length>`: An equal radius on all edges.
	- `[4x<length>]`: Individual border radii, starting at top left going clockwise.
- `outline = false` (`bool`): Whether the polygon should be outlined.
- `fillColor = "#ffffff"` (`<color>`): The color to fill with.
- `outlineColor = "#ffffff"` (`<color>`): The color to outline with.
- `outlineWidth = "1px"` (`<length>`): How thick outlines should be.
- `outlineStyle = "solid"` (`<line-style>`): The style of the outline lines.

### Ellipse (feature `ellipse-level1`)
- `size = [0, 0]` (`<size>`): The size of the ellipse.
- `arcRange = [0, 2pi]` (`[<angle>, <angle>]`): The angle range of the ellipse to draw.
- `fill = false` (`bool`): Whether the polygon should be filled.
- `outline = false` (`bool`): Whether the polygon should be outlined.
- `fillColor = "#ffffff"` (`<color>`): The color to fill with.
- `outlineColor = "#ffffff"` (`<color>`): The color to outline with.
- `outlineWidth = "1px"` (`<length>`): How thick outlines should be.
- `outlineStyle = "solid"` (`<line-style>`): The style of the outline lines.

### Operators (feature `operators-level1`)
Operators should have their `operator` field set to what operator they are.

The following operators are in PJVG level 1:
- `inverse`: Uses the `operand` field and returns the inverse of it.
- `union`: Uses a list field named `operands` and returns the union of those shapes.
- `intersection`: Uses a list field named `operands` and returns the intersection of those shapes.
- `link`: Uses a list field named `operands` of `polygon` and `bezier` shapes and links them togetther into a single polygon.

## Level 2 (feature `shapes-level2`)
All level 2 shapes:
- `bezier`: An arbitrary degree bezier curve.
- `text`: A piece of text.

### Bezier (feature `bezier-level2`)
- `points = []` (array of `<point>`): A list of points defining the curve.
- `outline = false` (`bool`): Whether to draw the outline of the curve.
- `outlineColor = #ffffff` (<color>): What color to draw the outline.
- `outlineWidth = "1px"` (`<length>`): How thick outlines should be.
- `outlineStyle = "solid"` (`<line-style>`): The style of the outline lines.

### Text (feature `text-level2`)
- `text = ""` (`string`): Text to draw.
- `box = null` (`null|<bounding-box>|"parent"`): How to box the text.
	- `null`: does no text wrapping, alignment, or boxing.
	- `<bounding-box>`: Wraps text and clips it on this box
	- `"parent"`: Only valid if the parent is a `rectangle` shape; wraps text to that shape.
- `horizontalAlign = "center"`: (`"left"|"center"|"right"`): Aligns text horizontally.
- `verticalAlign = "center"`: (`"top"|"center"|"bottom"`): Aligns text vertically.
- `fontSize = "12pt"` (`<length>`): The size of font to use.
- `fontFamily = ""` (`string`): The font family to try to use.
- `fontWeight = "normal"` (`<font-weight>`): The weight of font to try to use.
- `fontColor = "#ffffff"` (`<color>`): The color to draw the text with.