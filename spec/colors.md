# Colors
(draft 2)

## Level 1 (feature level `colors-level1`)
A color is defined as one of the following:
- A color array:
	- RGB, (`[r, g, b]`)
	- RGBA, (`[r, g, b, a]`)
- A color string with a hexcode:
	- RGB, two digits per channel (`#AABBCC`)
	- RGBA, two digits per channel (`#AABBCCDD`)
- A color string with a function:
	- `rgb(r, g, b)` and `rgba(r, g, b, a)`
		- `r`, `g`, and `b` are on [0, 255]
		- `a` is on [0, 1]
	- `hsv(h, s, v)` and `hsva(h, s, v, a)`
		- `h` is on [0, 360]
		- `s` and `v` are on [0, 1]
		- `a` is on [0, 1]
	- `hsl(h, s, l)` and `hsla(h, s, l, a)`
		- `h` is on [0, 360]
		- `s` and `l` are on [0, 1]
		- `a` is on [0, 1]