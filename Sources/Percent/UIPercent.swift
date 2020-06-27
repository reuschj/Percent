//
//  UIPercent.swift
//  
//
//  Created by Justin Reusch on 6/22/20.
//

import SwiftUI

/// Holds a scale for a UI element to set size dynamically based on the size of it's container
struct UIPercent: PercentProtocol {
    
    public typealias BaseType = CGFloat
    public typealias ExpressedAsPercent = PercentCGFloat
    public typealias ExpressedAsDecimal = DecimalCGFloat
    
    /// Private backing value for the percent property
    private var base: PercentCGFloat
    
    /// Percent represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
    public var percent: PercentCGFloat {
        get { base }
        set { base = limit(newValue, minimum: minimum, maximum: maximum) }
    }
    
    /// Percent represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
    public var decimal: DecimalCGFloat {
        get { percent.decimal }
        set { percent = newValue.percent }
    }
    
    /// The minimum percentage that can be stored (Optional)
    public var minimum: PercentCGFloat? = nil
    
    /// The maximum percentage that can be stored (Optional)
    public var maximum: PercentCGFloat? = nil
    
    /// Selects the container to scale to
    var container: ScaleContainer = .screen(.width)
    
    // 🐣 Initializers ------------------------------------------------ /
    
    /**
     Initialize with a percent (represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.)
     - Parameter percent: Percent represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
     - Parameter container: Selects the container to scale to
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(
        _ percent: PercentCGFloat = 100, of container: ScaleContainer = .screen(.width),
        minimum: PercentCGFloat? = nil,
        maximum: PercentCGFloat? = nil
    ) {
        self.minimum = minimum
        self.maximum = maximum
        self.base = limit(percent, minimum: minimum, maximum: maximum)
        self.container = container
    }
    
    /**
     Initialize with a percent (represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.)
     - Parameter percent: Percent represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(
        _ percent: PercentCGFloat = 100,
        minimum: PercentCGFloat? = nil,
        maximum: PercentCGFloat? = nil
    ) {
        self.init(percent, of: .screen(.width), minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a decimal (represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.)
     - Parameter decimal: Percent represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
     - Parameter container: Selects the container to scale to
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    init(
        decimal: DecimalCGFloat, of container: ScaleContainer = .screen(.width),
        minimum: PercentCGFloat? = nil,
        maximum: PercentCGFloat? = nil
    ) {
        self.init(decimal.percent, of: container, minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a string percent (represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.)
     - Parameter string: A percent represented as a string (like "100%", "50%", or "25.2%")
     - Parameter container: Selects the container to scale to
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init?(
        _ string: String, of container: ScaleContainer = .screen(.width),
        minimum: PercentCGFloat? = nil,
        maximum: PercentCGFloat? = nil
    ) {
        guard let value = Self.getValueOfStringPercent(string) else { return nil }
        self.init(value, of: container, minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a fraction (pass the numerator and denominator)
     - Parameter numerator: The numerator (top) of the fraction
     - Parameter denominator: The denominator (bottom) of the fraction
     - Parameter container: Selects the container to scale to
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(
        _ numerator: CGFloat,
        over denominator: CGFloat,
        of container: ScaleContainer = .screen(.width),
        minimum: PercentCGFloat? = nil,
        maximum: PercentCGFloat? = nil
    ) {
        self.init(decimal: (numerator / denominator), of: container, minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a fraction (pass the numerator and denominator)
     - Parameter numerator: The numerator (top) of the fraction
     - Parameter denominator: The denominator (bottom) of the fraction
     - Parameter container: Selects the container to scale to
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(
        _ numerator: Int,
        over denominator: Int,
        of container: ScaleContainer = .screen(.width),
        minimum: PercentCGFloat? = nil,
        maximum: PercentCGFloat? = nil
    ) {
        self.init(CGFloat(numerator), over: CGFloat(denominator), of: container, minimum: minimum, maximum: maximum)
    }
    
    /**
    Initialize with a fraction (pass the numerator and denominator)
    - Parameter numerator: The numerator (top) of the fraction
    - Parameter denominator: The denominator (bottom) of the fraction
    - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
    - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
    */
    public init(
        _ numerator: Int,
        over denominator: Int,
        minimum: PercentCGFloat? = nil,
        maximum: PercentCGFloat? = nil
    ) {
        self.init(CGFloat(numerator), over: CGFloat(denominator), of: .screen(.width), minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a fraction with 1 as the numerator (pass the denominator). For example, 1/4, or 1/2
     - Parameter denominator: The denominator (bottom) of the fraction
     - Parameter container: Selects the container to scale to
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(
        oneOver denominator: CGFloat, of container: ScaleContainer = .screen(.width),
        minimum: PercentCGFloat? = nil,
        maximum: PercentCGFloat? = nil
    ) {
        self.init(1, over: denominator, of: container, minimum: minimum, maximum: maximum)
    }
    
    /**
     Inits with a font size
     - Parameter fontSize: A font size that is scaled based on it's container. Should read as a full number percentage (of 100) of font height the overall container. (10 = 10%)
     - Parameter container: Selects the container to scale to
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    init(
        fontSize: PercentCGFloat, of container: ScaleContainer = .container(.height),
        minimum: PercentCGFloat? = nil,
        maximum: PercentCGFloat? = nil
    ) {
        self.init(fontSize, of: container, minimum: minimum, maximum: maximum)
    }
    
    // 🛠 Methods ------------------------------------------------ /
    
    /**
     Gets the fixed size from the scale within a given container
     - Parameter containerSize: The container size (just the relevant dimension, height or width)
     - Parameter range: A closed range of allowable sizes to constrain to (optional)
     */
    func getSize(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> CGFloat {
        let scaled = containerSize * decimal
        guard let range = range else { return scaled }
        if range.contains(scaled) { return scaled }
        if scaled > range.upperBound { return range.upperBound }
        if scaled < range.upperBound { return range.lowerBound }
        return scaled
    }
    
    /// String representation
    public var description: String {
        "\(Self.toStringPercent(percent)) of \(container)"
    }
    
    // Static ------------------------------------------------ /
    
    /**
     Converts a sting percentage to percent value
     - Parameter stringPercent: A percent represented as a string with % at the end (like "100%", "50%", or "25.2%")
     */
    public static func getValueOfStringPercent(_ stringPercent: String) -> PercentCGFloat? {
        guard let value = convertStringPercent(stringPercent) else { return nil }
        return CGFloat(value)
    }
    
    // Enums ------------------------------------------------ /
    
    /// Enum of containers within the app to scale to.
    /// Choose `container` to request scaling to a container
    enum ScaleContainer: Equatable, Comparable, CustomStringConvertible {
        case screen(Dimension = .width)
        case container(Dimension = .width, of: String? = nil)
        
        /// A private value to use in comparison.
        private var compareValue: Double {
            switch self {
            case .screen:
                return 1
            case .container:
                return 0.5
            }
        }
         
        /// Gets the store dimension
        var dimension: Dimension {
            switch self {
            case .screen(let dim):
                return dim
            case .container(let dim, _):
                return dim
            }
        }
        
        /// String representation
        var description: String {
            switch self {
            case .screen(let dim):
                return "screen \(dim)"
            case .container(let dim, let name):
                return "\(name?.description ?? "container") \(dim)"
            }
        }
            
        /**
         Compares to another container
         - Parameter lhs: A container to compare
         - Parameter rhs: Another container to compare to
         - Returns: If comparison was successful
         */
        public static func < (lhs: Self, rhs: Self) -> Bool {
            guard lhs.compareValue == rhs.compareValue else {
               return lhs.compareValue < rhs.compareValue
            }
            return lhs.dimension < rhs.dimension
        }
        
        /// The dimension of the container being scaled to.
        enum Dimension: Equatable, Comparable, CustomStringConvertible {
            case width
            case height
            case diameter
            case radius
            case other(description: String)
            
            /// String representation
            var description: String {
                switch self {
                case .width:
                    return "width"
                case .height:
                    return "height"
                case .diameter:
                    return "diameter"
                case .radius:
                    return "radius"
                case .other(let description):
                    return description
                }
            }
            
            /// A private value to use in comparison.
            /// We won't know actual lengths of each so we'll consider length, width and diameter to all be full container lengths (1) and radius to be half (0.5)
            private var compareValue: Double {
                switch self {
                case .radius:
                    return 0.5
                default:
                    return 1
                }
            }
            
            /**
             Compares to another dimension
             - Parameter lhs: A dimension to compare
             - Parameter rhs: Another dimension to compare to
             - Returns: If comparison was successful
             */
            public static func < (lhs: Self, rhs: Self) -> Bool {
                lhs.compareValue < rhs.compareValue
            }
        }
    }
    
    // 🍎==🍏❔ Equality ------------------------------------------------ /
    
    /**
     Checks equality
     - Parameter lhs: A percent to compare
     - Parameter rhs: Another percent to compare to
     - Returns: If equality check was successful
     */
    public static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.percent == rhs.percent) && (lhs.container == rhs.container)
    }
    
    // 🍎<🍏❔ Comparison ------------------------------------------------ /
    
    /**
     Compares to another percent
     - Parameter lhs: A percent to compare
     - Parameter rhs: Another percent to compare to
     - Returns: If comparison was successful
     */
    public static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.percent < rhs.percent) && (lhs.container < rhs.container)
    }
    
    // ➕➖✖️➗ Arithmetic ------------------------------------------------ /
    
    /**
     Adds two percents together to make a new percent.
     For example, 50% + 5% = 55%
     - Parameter lhs: A base percent to add to (the new percent will follow the minimum/maximum set on the this percent)
     - Parameter rhs: A percent to add to the first
     - Returns: A new percent bounded by the minimum/maximum set on the left percent
     */
    public static func + (lhs: Self, rhs: Self) -> Self {
        let combined = lhs.percent + rhs.percent
        return Self.init(combined, of: lhs.container, minimum: lhs.minimum, maximum: lhs.maximum)
    }
    
    /**
     Finds the difference of two percents.
     For example, 50% - 5% = 45%
     - Parameter lhs: A base percent to subtract from (the new percent will follow the minimum/maximum set on the this percent)
     - Parameter rhs: A percent to subtract from the first
     - Returns: A new percent bounded by the minimum/maximum set on the left percent
     */
    public static func - (lhs: Self, rhs: Self) -> Self {
        let difference = lhs.percent - rhs.percent
        return Self.init(difference, of: lhs.container, minimum: lhs.minimum, maximum: lhs.maximum)
    }
    
    /**
     Finds the product of two percents.
     For example, 50% * 50% = 25%
     - Parameter lhs: A base percent to multiply (the new percent will follow the minimum/maximum set on the this percent)
     - Parameter rhs: A percent to multiply the first by
     - Returns: A new percent bounded by the minimum/maximum set on the left percent
     */
    public static func * (lhs: Self, rhs: Self) -> Self {
        let product = lhs.decimal * rhs.decimal
        return Self.init(decimal: product, of: lhs.container, minimum: lhs.minimum, maximum: lhs.maximum)
    }
    
    /**
     Multiplies a percent by the the specified number.
     For example, 50% * 2 = 100%
     - Parameter lhs: A percent to multiply
     - Parameter rhs: A number to multiply the percent by
     - Returns: A new percent bounded by the minimum/maximum set on the left percent
     */
    public static func * (lhs: Self, rhs: BaseType) -> Self {
        let product = lhs.decimal * rhs
        return Self.init(product, of: lhs.container, minimum: lhs.minimum, maximum: lhs.maximum)
    }
    
    /**
     Divides a number by the the specified percent (In other words, divided by the decimal).
     For example, 50% / 2 = 25%
     - Parameter lhs: A percent to divide
     - Parameter rhs: A number to divide the percent by
     - Returns: A new percent bounded by the minimum/maximum set on the left percent
     */
    public static func / (lhs: Self, rhs: BaseType) -> Self {
        let quotient = lhs.percent / rhs
        return Self.init(quotient, of: lhs.container, minimum: lhs.minimum, maximum: lhs.maximum)
    }
}

