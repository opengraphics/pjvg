# Document
(draft 1)

## Level 1
A PJVG document has the following fields:
- `size`: A size field denoting the base/relative size of the element. It gives a baseline size and an aspect ratio for the document.
- `children` (optional): A list of children that the document contains. 
- `scale` (optional): A scale field used to resize the document.
- `rasterScaleMethod` (optional): The method to be preferred to rescale this document. Must be:
	- `nearest`: Nearest-neighbor interpolation
	- `linear`: Linear interpolation

A document in JSON might look like:
```json
{
	"size": ["1920px", "1080px"],
	"scale": [1, 1],
	"rasterScaleMethod": "linear",
	"children": [
	]
}
```