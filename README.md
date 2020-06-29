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

## Initializing

`Percent` is initiated in any one of several different ways:

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

A `Percent` is `CustomStringConvertible` so will represent itself as a string in the form of "50%" or "25%".

You may notice the types `PercentDouble` and `DecimalDouble`. Both are just type aliases for `Double` and can be used interchangeably with `Double`. `PercentDouble` should indicate that the number should be a percent (over 100) and `DecimalDouble` should indicate that the number should be a decimal (over 1). For example, 50% is 50 as a `PercentDouble`, but 0.5 as a `DecimalDouble`.

### Constraining to minimum and/or maximum

You can also set an optional minimum and/or maximum value to constrain to. These are purely optional, but may be useful if receiving the percent as input and want to set an allowable range. For example:

```swift
// Assume `input` is a `DecimalDouble` we are getting from input. It could be anything, and may be out of our acceptable bounds.

// Let's constrain the input to be within 0% to 100%... if under, it will snap to the minimum. If over, it will snap to the maximum.
let percent01 = Percent(decimal: input, minimum: 0, maximum: 100)

// In this case, we'll only set a minimum, but won't set any upper bounds.
let percent02 = Percent(decimal: input, minimum: 0)

// In this case, we'll only set a maximum, but won't set any lower bounds.
let percent03 = Percent(decimal: input, maximum: 100)

// Omitting both minimum and maximum will allow any value we get from input
let percent04 = Percent(decimal: input)
```

## Percent comparison

A `Percent` is `Equatable` and `Comparable` and be compared with any other `Percent`.

```swift
let percent01 = Percent(50)
let percent02 = Percent(50)
let percent03 = Percent(25)

print(percent01 == percent02) // true
print(percent01 == percent03) // false
print(percent01 >= percent02) // true
print(percent01 > percent03) // true
```

A `Percent` can be compared to a `DecimalDouble`:

```swift
let percent01 = Percent(50)

print(percent01 >= 0.5) // true
print(percent01 > 0.3) // false
print(percent01 < 0.75) // true
```

Note that this will not work:

```swift
print(percent01 == 0.5) // false
```

This is because they effectively have the same value, but aren't the same type. So, this can't be checked with the `==` operator, since that would imply them to be the same value _and_ the same type. Instead, if you need to verify that a `Percent` has the same value as a decimal, while not implying complete equality, you can use this method:

```swift
print(percent01.isEquivalentTo(decimal: 0.5)) // true
```

## Percent arithmetic

A `Percent` can be combined with another `Percent`.

```swift
print(Percent(50) + Percent(5)) // 55%
print(Percent(50) - Percent(5)) // 45%
print(Percent(50) * Percent(50)) // 25%
print(Percent(50) / Percent(25)) // 2
```

A `Percent` can also be combined with a `Double`.

```swift
print(10 + Percent(50)) // 15 <-- 10 + (10 * 0.5)
print(10 - Percent(50)) // 5 <-- 10 - (10 * 0.5)
print(10 * Percent(50)) // 5 <-- 10 * 0.5
print(10 / Percent(50)) // 20 <-- 10 / 0.5
print(Percent(25) * 2) // 50%
print(Percent(50) / 2) // 25%
```

# UIPercent

For use in UI, use a `UIPercent`. It works like a `Percent`, with a few extras for UI.  `Percent` and `UIPercent` both implement the `PercentProtocol` protocol, so have many of the same capabilities. However, where `Percent` is based on the `Double` type and good for general arithmetic, `UIPercent` is based on `CGFloat`, so is better aligned to dealing with UI measurements.

Also, `UIPercent` adds in the ability to set a scaling container of type `ScaleContainer`. `ScaleContainer` is an enum specifying a container that the percent intends to scale to. For example:

```swift
GeometryReader { geometry in
    let width = UIPercent(25, of: .screen(.width))
    let height = UIPercent(50, of: .screen(.height))
    let screenSize: CGSize = geometry.size
    let resolvedWidth = width.resolve(within: screenSize)
    let resolvedHeight = height.resolve(within: screenSize)
}
```
The `ScaleContainer` enum has two cases, `.screen` and `.container`. `.screen` communicates that you are intending to scale to the full screen and `.container` communicates that you intend to scale to some other container within the UI. Either way, you must specify the dimension of this container to scale to. `ScaleContainer.Dimension` is an enum with cases `.height`, `.width`, `.radius`, `.diameter` and `.other` (anything not covered by the other cases).

If you scale to `.container`, you can also pass a string description. For example:

```swift
let handLength = UIPercent(90, of: .container(.radius, "clock"))
```

You can use the `resolve(within: CGFloat, limitedTo: ClosedRange<CGFloat>?)`, `resolve(within: CGSize, limitedTo: ClosedRange<CGFloat>?)`  or `resolve(within: GeometryProxy, limitedTo: ClosedRange<CGFloat>?)`  method of `UIPercent` to get the fixed value within the specified container. The second parameter is optional if you want to constrain that resolved value to an allowable range.