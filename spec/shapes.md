# Shapes
(draft 1)

Shapes in PJVG denote anything that can be drawn. They have an object type of "shape".

## Level 1
Level 1 PJVG shapes:
- `polygon`: A list of points forming a closed polygon.
- `bezier`: An arbitrary degree bezier curve.
- `text`: A piece of text.
- `rectangle`: A polygon with four points and extra flow features.

### Shape
All shapes can have the following fields:
- `position = [0, 0]` (`<position>`): The position of the shape relative to its parent.
- `scale = [1, 1]` (`<scale>`): The scale the object should be drawn at.
- `rotation = 0` (`<rotation>`): The rotation of the object.
- `rotationOffset = ["50%", "50%"]` (`<point>`): A point relative to the upper-left corner to rotate around.
- `translation = [0, 0]` (`<position>`): A position to translate the object with.
- `clip = null` (`null|<bounding-box>|<shape>`): Defines a clipping box or shape for this object. Null is no clipping.
- `children = []` (`array`): An array of children that this object has.

### Polygon
A polygon has the following fields:
- `points = []` (`array`): A list of points that the polygon has relative to the top-left.
- `fill = false` (`bool`): Whether the polygon should be filled.
- `outline = false` (`bool`): Whether the polygon should be outlined.
- `fillColor = "#ffffff"` (`<color>`): The color to fill with.
- `outlineColor = "#ffffff"` (`<color>`): The color to outline with.
- `outlineWidth = "1px"` (`<length>`): How thick outlines should be.

### Bezier
- `points = []` (array of `<point>`): A list of points defining the curve.
- `outline = false` (`bool`): Whether to draw the outline of the curve.
- `outlineColor = #ffffff` (<color>): What color to draw the outline.
- `outlineWidth = "1px"` (`<length>`): How thick outlines should be.

### Text
- `text = ""` (`string`): Text to draw.
- `box = null` (`null|<bounding-box>|"parent"): How to box the text.
	- `null`: does no text wrapping, alignment, or boxing.
	- `<bounding-box>`: Wraps text and clips it on this box
	- `"parent"`: Only valid if the parent is a `rectangle` shape; wraps text to that shape.
- `horizontalAlign = "center"`: (`"left"|"center"|"right"`): Aligns text horizontally.
- `verticalAlign = "center"`: (`"top"|"center"|"bottom"`): Aligns text vertically.
- `fontSize = "12pt"` (`<length>`): The size of font to use.
- `fontFamily = ""` (`string`): The font family to try to use.
- `fontWeight = "normal"` (`<font-weight>`): The weight of font to try to use.
- `fontColor = "#ffffff"` (`<color>`): The color to draw the text with.

### Rectangle
- `size = [0, 0]` (`<size>`): The size of the rectangle.
- `fill = false` (`bool`): Whether the polygon should be filled.
- `radius = null` (`null|<length>`): The radius of the edges of the rectangle. `null` denotes no rounded edges.
- `outline = false` (`bool`): Whether the polygon should be outlined.
- `fillColor = "#ffffff"` (`<color>`): The color to fill with.
- `outlineColor = "#ffffff"` (`<color>`): The color to outline with.
- `outlineWidth = "1px"` (`<length>`): How thick outlines should be.