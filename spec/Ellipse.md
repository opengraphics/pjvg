# Type: Ellipse
An `Ellipse` is a [`Shape`](Shape.md) representing an ellipse.

The type has all properties of the type `Frame`.

The type has the following required properties:
- `type` (`"ellipse"`)
- `radii` (`[number, number]`): The radius of the ellipse on each axis.

The type has the following optional properties:
- `range` (`[number, number]`): An inclusive range of angles to include, defined in centirevolutions.
	- Default: `[0, 1]`
- `fillColor` (`color`): The color to fill the polygon with.
	- Default: `false`
- `outlineColor` (`color`): The color to outline the polygon with.
	- Default: `false`
- `outlineWidth` (`number`): The width of the outline. Must be specified if `outlineColor` is defined.

The center of the ellipse is located at its `position`.

## Examples
A circle
```json
{
	"type": "ellipse",
	"radii": [1, 1],
	"fillColor": ["rgb", 0, 255, 0]
}
```

```json
{
	"type": "ellipse",
	"position": [0.5, 1],
	"radii": [1, 2],
	"fillColor": ["rgb", 255, 255, 255],
	"outlineColor": ["rgb", 0, 0, 0]
}
```