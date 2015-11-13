# Type: Polygon
A `Polygon` is a [`Shape`](Shape.md) representing a list of points.

A Polygon has no requirements to be closed or convex/concave.

The type has all properties of the type `Frame`.

The type has the following required properties:
- `type` (`"polygon"`)
- `points` (`[number, number][]`): A list of points the polygon has.

The type has the following optional properties:
- `fillColor` (`color`): The color to fill the polygon with.
	- Default: `false`
- `outlineColor` (`color`): The color to outline the polygon with.
	- Default: `false`
- `outlineWidth` (`number`): The width of the outline. Must be specified if `outlineColor` is defined.