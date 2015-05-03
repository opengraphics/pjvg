# Objects
(draft 3)

As of the current draft, the following objects are valid in PJVG:
- `document`: A full document tree (see [document](document.md))
- `shape`: A PJVG shape (see [shapes](shapes.md))

All objects must have the following fields:
- `type`: The type of the object, must be one of the above fields.
- `name` (optional): A reference name for the object unique among it and its siblings.

This means that a PJVG document has a structure like:
```json
{
	"type": "<object type>",
	"name": "<object name>"
}
```