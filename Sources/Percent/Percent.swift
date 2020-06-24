//
//  Percent.swift
//
//
//  Created by Justin Reusch on 6/20/20.
//

import Foundation

/// Holds a percentage as a value
public struct Percent: PercentProtocol {
    
    public typealias BaseType = Double
    public typealias ExpressedAsPercent = PercentDouble
    public typealias ExpressedAsDecimal = DecimalDouble
    
    /// Private backing value for the percent property
    private var percentValue: PercentDouble = 0
    
    /// Percent represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
    public var percent: PercentDouble {
        get { percentValue }
        set { percentValue = limit(newValue, minimum: minimum, maximum: maximum) }
    }
    
    /// Percent represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
    public var decimal: DecimalDouble {
        get { percent.decimal }
        set { percent = newValue.percent }
    }
    
    /// The minimum percentage that can be stored (Optional)
    public var minimum: PercentDouble? = nil
    
    /// The maximum percentage that can be stored (Optional)
    public var maximum: PercentDouble? = nil
    
    // 🐣 Initializers ------------------------------------------------ /
    
    /**
     Initialize with a percent (represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.)
     - Parameter percent: Percent represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(_ percent: PercentDouble = 100, minimum: PercentDouble? = nil, maximum: PercentDouble? = nil) {
        self.minimum = minimum
        self.maximum = maximum
        self.percentValue = limit(percent, minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a decimal (represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.)
     - Parameter decimal: Percent represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(decimal: DecimalDouble, minimum: PercentDouble? = nil, maximum: PercentDouble? = nil) {
        self.init(decimal.percent, minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a string percent (represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.)
     - Parameter string: A percent represented as a string (like "100%", "50%", or "25.2%")
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init?(_ string: String, minimum: PercentDouble? = nil, maximum: PercentDouble? = nil) {
        guard let value = Self.getValueOfStringPercent(string) else { return nil }
        self.init(value, minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a fraction (pass the numerator and denominator)
     - Parameter numerator: The numerator (top) of the fraction
     - Parameter denominator: The denominator (bottom) of the fraction
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(_ numerator: Double, over denominator: Double, minimum: PercentDouble? = nil, maximum: PercentDouble? = nil) {
        self.init(decimal: (numerator / denominator), minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a fraction (pass the numerator and denominator)
     - Parameter numerator: The numerator (top) of the fraction
     - Parameter denominator: The denominator (bottom) of the fraction
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(_ numerator: Int, over denominator: Int, minimum: PercentDouble? = nil, maximum: PercentDouble? = nil) {
        self.init(Double(numerator), over: Double(denominator), minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a fraction with 1 as the numerator (pass the denominator). For example, 1/4, or 1/2
     - Parameter denominator: The denominator (bottom) of the fraction
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(oneOver denominator: Double, minimum: PercentDouble? = nil, maximum: PercentDouble? = nil) {
        self.init(1, over: denominator, minimum: minimum, maximum: maximum)
    }
    
    /**
     Initialize with a fraction with 1 as the numerator (pass the denominator). For example, 1/4, or 1/2
     - Parameter denominator: The denominator (bottom) of the fraction
     - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
     - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
     */
    public init(oneOver denominator: Int, minimum: PercentDouble? = nil, maximum: PercentDouble? = nil) {
        self.init(1, over: denominator, minimum: minimum, maximum: maximum)
    }
    
    // 🛠 Methods ------------------------------------------------ /
    
//    /**
//     Applies the percentage to a number to get the percentage of that number
//     - Parameter number: The number to get  a percentage of
//     */
//    public func of(number: Double) -> Double { number * decimal }
//
//    /**
//     Applies the percentage to a number to get the percentage of that number
//     - Parameter number: The number to get  a percentage of
//     */
//    public func of(number: Int) -> Double { Double(number) * decimal }
    
    /// String representation
    public var description: String { Self.toStringPercent(value: percent) }
    
    // Static ------------------------------------------------ /
    
    /**
     Converts a sting percentage to percent value
     - Parameter stringPercent: A percent represented as a string with % at the end (like "100%", "50%", or "25.2%")
     */
    public static func getValueOfStringPercent(_ stringPercent: String) -> PercentDouble? {
        guard stringPercent.last == "%" else {
            return Double(stringPercent)
        }
        let index = stringPercent.index(stringPercent.endIndex, offsetBy: -1)
        let rest = stringPercent[..<index]
        return Double(rest)
    }
    
    /**
     Converts a sting percentage to percent decimal
     - Parameter stringPercent: A percent represented as a string (like "100%", "50%", or "25.2%")
     */
    public static func getDecimalOfStringPercent(_ stringPercent: String) -> DecimalDouble? {
        guard let value = Self.getValueOfStringPercent(stringPercent) else { return nil }
        return value.decimal
    }
    
    /**
     Checks if a string can be converted to a percent
     - Parameter value: A percent represented as a string (like "100%", "50%", or "25.2%")
     */
    public static func isStringPercent(_ value: String) -> Bool {
        guard let _ = Self.getValueOfStringPercent(value) else { return false }
        return true
    }
    
    /**
     Converts a percent value to string
     - Parameter value: A double that expresses a percentage as a while number. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
     */
    public static func toStringPercent(value: PercentDouble) -> String {
        return "\(value.removeTrailingZeros)%"
    }
    
    /**
     Converts a percent decimal to string
     - Parameter value: A double that expresses a percentage as a while number. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
     */
    public static func toStringPercent(decimal: DecimalDouble) -> String {
        return "\(decimal.percent)%"
    }
}
