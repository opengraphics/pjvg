# Type: Tangible
A `Tangible` Shape is any [`Shape`](Shape.md) that can be transformed with a defined set of transformations.

The type has all properties of the type `Shape`.

The type has the following optional properties:
- `position` (`[number, number]`): The position of the shape relative to its parent.
	- Default: `[0, 0]`
- `scale` (`[number, number]`): The scale of the object on each axis.
	- Default: `[1, 1]`
- `rotation` (`number`): The rotation of the shape in centirevolutions.
	- Default: `0`
- `rotationOffset` (`[number, number]`): An offset to rotate the Shape around.