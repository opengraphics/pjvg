# PJVG Selectors
(draft 0)

Selectors in PJVG are different than most other DOM implementations.

From a given element, a selector can use:
- `this` to reference itself
- `@document` to reference the document root, or anything else in the first level of the PJVG model
- `#element` to reference an element by ID
- `#nav:to:children` to navigate to children
- `#nav^:toSibling` to navigate to a sibling element
- `#element.property` to reference a property of the element