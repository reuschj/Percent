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
    private var base: PercentDouble = 0
    
    /// Percent represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
    public var percent: PercentDouble {
        get { base }
        set { base = limit(newValue, minimum: minimum, maximum: maximum) }
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
    public init(
        _ percent: PercentDouble = 100,
        minimum: PercentDouble? = nil,
        maximum: PercentDouble? = nil
    ) {
        self.minimum = minimum
        self.maximum = maximum
        self.base = limit(percent, minimum: minimum, maximum: maximum)
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
        minimum: PercentDouble? = nil,
        maximum: PercentDouble? = nil
    ) {
        self.init(Double(numerator), over: Double(denominator), minimum: minimum, maximum: maximum)
    }
    
    // Static ------------------------------------------------ /
    
    /**
     Converts a sting percentage to percent value
     - Parameter stringPercent: A percent represented as a string with % at the end (like "100%", "50%", or "25.2%")
     */
    public static func getValueOfStringPercent(_ stringPercent: String) -> PercentDouble? {
        return convertStringPercent(stringPercent)
    }
}
