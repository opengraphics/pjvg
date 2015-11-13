# Type: Shape
A shape represents any object that is independently drawable.

The type has the following required fields:
- `type` (`string`): The type of shape.

Type names must be one of those listed in the specification or a valid vendor shape name. Shape type defined by applications must be of the form `x-shapeTypeName` to prevent collisions with future standards.

Shapes of unknown types should be ignored, including any children they may contain.

Vendor shape names of critical display should be paired with a vendor feature name in the media's [`Container`](./Container.md) to prevent standards-compliant implementations from misinterpreting the document.

## Examples
```json
{
	"type": "document"
}
```

```json
{
	"type": "x-animatedSprite",
	"source": "uniqueResourceName",
	"frames": [1, 2, 3, 2, 1]
}
```

```json
{
	"type": "x-svg",
	"source": "other-document.svg"
}
```