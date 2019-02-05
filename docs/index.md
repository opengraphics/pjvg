PJVG is a lean JSON-based vector graphics format with a focus on simplicity.

[TOC]

## Goals
- Easy to implement renderer from scratch
- Support software and hardware rendering

## Document Structure
```json
{
  "pjvg": 0,
  "extensions": [],
  "content": [
    {
      "type": "shape",
      "segments": [
        {
          "type": "lines",
          "points": [
            [0, 0],
            [0, 100],
            [100, 100],
          ]
        },
        {
          "type": "cubic-bezier",
          "points": [
            [100, 100],
            [100, 0],
            [50, 50],
            [0, 0],
          ]
        }
      ],
      "fill": {
        "type": "solid",
        "color": {
          "type": "srgb",
          "value": [0.752, 0.432, 0.192]
        }
      }
    }
  ]
}
```