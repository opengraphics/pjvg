# Selectors
(draft 3)

PJVG supports selectors to look up objects in a document.

## Level 1 (feature `selectors-level1`)
Level 1 selectors begin with an arobase (`@`) followed by a series of lookups delimited by periods (`.`).

Elements in the selector can either be numbers (to select children by numbers), strings (to select properties), or strings prefaced with a waffle (`#`) to select an element by its name. Selectors must only select a single element.

Example selectors:
- `@1` selects the first element in the root
- `@#name` selects the element with name `name` in the root
- `@1.1` selects the first element within the first element in the root
- `@#a.#b` selects `a` in the root, then `b` inside `a`.
- `@#a.size.1` selects the horizontal component of the size of `a`.