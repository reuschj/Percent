# Percent

The `Percent` type stores a value representing a percent (over 100). Normally, we would need to use decimals for calculations involving percents. However, decimals could be confused for absolute values. Let's look at this example:

```swift
let container: Double = 40
let widthScale: Double = 0.5
let width: Double = container * widthScale // 20
```

In the example above, we may not set an absolute value for something that should be a certain percent of some other value, so we could represent this with a decimal, but it's unclear if 0.5 means the absolute value is 0.5 or 50%.

Enter, `Percent`, which makes the intention more clear:

```swift
let container: Double = 40
let widthScale = Percent(50)
let width: Double = container * widthScale // 20
```

So, we can use it the same way, but now the intention is very clear.

`Percent` is initiated in one of several different ways:

```swift
// By entering the percent (the number that gives you the decimal value when divided by 100)
let widthScale01 = Percent(50) // 50%

// By entering the decimal value
let widthScale02 = Percent(decimal: 0.5) // 50%

// By entering a string (Note that this produce an Optional, since you could enter an invalid value that will fail)
let widthScale03 = Percent("50%") // Optional(50%)
let widthScale04 = Percent("50") // Optional(50%) <-- This works too
let widthScale05 = Percent("fifty percent") // nil <-- Sorry, this doesn't work

// By entering a numerator and denominator
let widthScale06 = Percent(1, over: 2) // 50%

// By entering a one over denominator
let widthScale07 = Percent(oneOver: 2) // 50%
```