# JSON Path

## Check item value from array

```json
[
    10,
    20,
    30,
    40,
    50,
    60,
    70
]
// Each item in the list - @
$[?(@ > 40)]
@ == 40
@ != 40
@ in [40,41,42]
@ nin [40,43,45]

// Check criterie in search

$.car.wheels[0].model
$.car.wheels[?(@.location == "rear-right")].model
```