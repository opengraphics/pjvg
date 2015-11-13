# Type: Document
A Document is container element for all other PJVG shapes. It is a [`Shape`](./Shape.md).

The type has the following required fields:
- `type` (`"document"`)
- `size` (`[number, number]`): The size of the Document.

The type has the following optional fields:
- `children` ([`Shape[]`](./Shape.md)): A list of children that the document contains.

## Examples
```json
{
	"type": "document",
	"size": [100, 100],
	"children": []
}
```