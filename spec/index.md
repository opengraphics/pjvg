# PJVG Specification
PJVG is a lean JSON-based vector image format. A PJVG document consists of a JSON object at the root with some properties and a list of objects to render.

[linktest](linktest)

A PJVG document has the following fields:
```json
{
	"pjvgVersion": [1, 0, 0, "draft"],
	"colors": {},
	"fonts": {},
	"document": [
	]
}
```

A PJVG object has the following format as a base:
```json
{
	"type": "<object type>",
}
```