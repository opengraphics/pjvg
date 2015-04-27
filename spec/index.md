# PJVG Specification
(draft 0)

PJVG is a lean JSON-based vector image format. A PJVG document consists of a JSON object at the root with some properties and a list of PJVG objects to render.

A PJVG document has the following fields:
- `pjvgVersion`: A list denoting the version of PJVG. Currently always `[0, 0, 0, "draft"]`
- `colors` (optional): An object containing a list of colors for the PJVG to use by reference.
- `fonts` (optional): An object containing a list of fonts for the PJVG to use by reference.
- `document` (optional): A list of PJVG objects at the top level.

A PJVG document might look like  this:
```json
{
	"format": "pjvg",
	"version": [0, 0, 0, "draft"],
	"classes": {
	},
	"colors": {
		"red": [255, 0, 0],
		"white": [255, 255, 255]
	},
	"fonts": {
		"$default": {
			"family": "Helvetica"
		}
	},
	"document": {
		"children": [
			{
				"type": "shape",
				"shape": "rectangle",
				"filled": true,
				"color": "@colors.red",
				"position": [0, 0],
				"size": ["50%", "50%"],
				"padding": ["4px", "4px", "4px", "4px"],
				"children": [
					{
						"type": "shape",
						"shape": "text",
						"color": "@colors.white",
						"clip": [[0, 0], ["100%", "100%"],
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

A PJVG object has the following format as a base:
```json
{
	"type": "<object type>",
}
```