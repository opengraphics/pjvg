# Shape Operators
(draft 1)

Shape operators function on shapes to return compound shapes. They have a type of `"shape-operator"` and have their `operator` field set to what operator they are.

## Level 1
The following operators are in PJVG level 1:
- `inverse`: Uses the `operand` field and returns the inverse of it.
- `union`: Uses a list field named `operands` and returns the union of those shapes.
- `intersection`: Uses a list field named `operands` and returns the intersection of those shapes.