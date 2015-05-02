# PJVG Specification
(draft 2)

PJVG is a lean JSON-based vector image format. A PJVG document consists of a JSON object at the root with some properties and a list of PJVG objects to render.

A PJVG document has the following fields:
- `format`: The string "pjvg".
- `version`: A list denoting the minimum version of PJVG this document is designed for. Currently always `[0, 0, 0, "draft"]`.
- `features`: A list of features this PJVG document expects to be present.
- `document` (optional): A PJVG `document` object denoting the root element.

Most features are of the form `<feature-name>-<level>-<version>` where `<version>` is optional. If defined, `<version>` must have the same major version number as the document.

For example, `rectangle-level1` implies support of the level 1 specification of rectangles. The version of rectangles supported is the same as the stated version of the document.

Another example, `rectangle-level1-1.1.0` means that this document requires some feature from specification version `1.1.0`'s additions to level 1 rectangle rendering.

The following extra feature levels are defined:
- `level1`: All level 1 features
- `level2`: All level 2 features, implies `level1`.

A PJVG document might look like this:
```json
{
	"format": "pjvg",
	"version": [0, 0, 0, "draft"],
	"features": ["level1"],
	"document": {
		"type": "document",
		"size": ["800px", "400px"],
		"children": [
			{
				"type": "shape",
				"shape": "rectangle",
				"filled": true,
				"color": [255, 0, 0],
				"position": [0, 0],
				"size": ["50%", "50%"],
				"padding": ["4px", "4px", "4px", "4px"],
				"children": [
					{
						"type": "shape",
						"shape": "text",
						"color": [255, 255, 255],
						"clip": [[0, 0], ["100%", "100%"]],
						"align": "center",
						"fontSize": "fill",
						"text": "Hello, world!"
					}
				]
			}
		]
	}
}
```