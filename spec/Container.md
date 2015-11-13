# Type: Container
A Container is the root object in the tree of a complete PJVG media.

A PJVG container has the following fields:
- `format` (`string`): The value "pjvg".
- `version` (`string`): The version of PJVG this container is designed for.
- `features` (`string[]`): The features this container requires.
- `document` ([`Document`](./Document.md)): An object denoting the root element.

The following fields may also be present, and are optional:
- `metadata` (`object`): A hashmap of metadata fields about the media.
	- `author` (`string`): The author of the media.
	- `license` (`string`): The license associated with the media.
- `extra` (`object`): Extra, application-specific fields about the media.

## Examples
```json
{
	"format": "pjvg",
	"version": "0.0.0-p5a",
	"features": [],
	"document": {
		"size": [0, 0]
	},
	"metadata": {
		"author": "The PJVG Group",
		"license": "public domain"
	}
}
```