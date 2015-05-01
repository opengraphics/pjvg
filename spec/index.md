# PJVG Specification
(draft 1)

PJVG is a lean JSON-based vector image format. A PJVG document consists of a JSON object at the root with some properties and a list of PJVG objects to render.

A PJVG document has the following fields:
- `format`: The string "pjvg".
- `version`: A list denoting the version of PJVG. Currently always `[0, 0, 0, "draft"]`.
- `level`: The feature level of PJVG this document expects. Feature levels above 1 are presently not defined.
- `extensions` (optional): A list of extensions this PJVG document expects.
- `document` (optional): A PJVG `document` object denoting the root element.

A PJVG document might look like this:
```json
{
	"format": "pjvg",
	"version": [0, 0, 0, "draft"],
	"level": 1,
	"extensions": [],
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