# PJVG: Primitives
Primitives in PJVG are datatypes that are used by several fields and types of fields.

PJVG inherits all types defined in JSON:
- number
- string
- boolean
- null
- array
- object

Additionally, PJVG defines the following extra types:

## Color
A color is an array containing a string format followed by a list of numbers.

The following formats are defined:

### `rgb`
A list of three numbers on [0, 255] defining a linear-space RGB color. Decimals may be rounded by implementations according to the algorithm defined in [the rendering notes document](./Rendering.md).

Optionally, a fourth number defines alpha.

### `hsl`
A list of three numbers defining an HSL color:
	- hue (on [0, 360])
	- saturation (on [0, 100])
	- lightness (on [0, 100])

Optionally, a fourth number defines alpha.

### `hsv`
A list of three numbers defining an HSV color:
	- hue (on [0, 360])
	- saturation (on [0, 100])
	- value (on [0, 100])

Optionally, a fourth number defines alpha.