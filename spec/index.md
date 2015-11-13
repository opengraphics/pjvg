# PJVG Specification
PJVG is a lean JSON-based vector image format. A PJVG container consists of a JSON object at the root with some properties and a list of PJVG objects to render.

A comprehensive list of types is as follows:
- [`Container`](./Container.md)
- [`Shape`](./Shape.md)
- [`Document`](./Document.md)
- [`Tangible`](./Tangible.md)
- [`Frame`](./Frame.md)
- [`Polygon`](./Polygon.md)
- [`Ellipse`](./Ellipse.md)

## Extensions
There are no defined extensions to PJVG at this time. When there are, they will be located in `extensions` directory under this one.