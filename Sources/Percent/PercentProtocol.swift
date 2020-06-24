//
//  PercentProtocol.swift
//
//
//  Created by Justin Reusch on 6/20/20.
//

import Foundation

/// Holds a percentage as a value
public protocol PercentProtocol: CustomStringConvertible, Hashable, Comparable {
    
    // Associated types ------------------------------------------------ /
    
    associatedtype BaseType: FloatingPoint
    
    /// A type alias of the base type represented as an amount over 100.
    associatedtype ExpressedAsPercent where ExpressedAsPercent == BaseType
    
    /// A type alias of the base type represented as a decimal.
    associatedtype ExpressedAsDecimal where ExpressedAsDecimal == BaseType
    
    // Properties ------------------------------------------------ /
    
    /// Percent represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
    var percent: ExpressedAsPercent { get set }
    
    /// Percent represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
    var decimal: ExpressedAsPercent { get set }
    
    /// The minimum percentage that can be stored (Optional)
    var minimum: ExpressedAsDecimal? { get set }
    
    /// The maximum percentage that can be stored (Optional)
    var maximum: ExpressedAsPercent? { get set }
    
    // 🐣 Initializers ------------------------------------------------ /
    
    init(_ percent: ExpressedAsPercent, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    init(decimal: ExpressedAsDecimal, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    init?(_ string: String, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    init(_ numerator: BaseType, over denominator: BaseType, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    init(_ numerator: Int, over denominator: Int, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    init(oneOver denominator: BaseType, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    init(oneOver denominator: Int, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    
    // 🛠 Methods ------------------------------------------------ /
    
    func of(number: BaseType) -> BaseType
    func of(number: Int) -> BaseType
}

/// Default implementations
extension PercentProtocol {
    
    // 🛠 Methods ------------------------------------------------ /
    
    /**
     Applies the percentage to a number to get the percentage of that number
     - Parameter number: The number to get  a percentage of
     */
    public func of(number: BaseType) -> BaseType { number * decimal }
    
    /**
     Applies the percentage to a number to get the percentage of that number
     - Parameter number: The number to get  a percentage of
     */
    public func of(number: Int) -> BaseType { BaseType.init(number) * decimal }
    
    /// Hash function
    public func hash(into hasher: inout Hasher) {
        hasher.combine(percent)
    }

    // 🍎==🍏❔ Equality ------------------------------------------------ /

    /**
     Checks equality
     - Parameter lhs: A percent to compare
     - Parameter rhs: Another percent to compare to
     - Returns: If equality check was successful
     */
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.percent == rhs.percent
    }
    
    // 🍎<🍏❔ Comparison ------------------------------------------------ /

    /**
     Compares to another percent
     - Parameter lhs: A percent to compare
     - Parameter rhs: Another percent to compare to
     - Returns: If comparison was successful
     */
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.percent < rhs.percent
    }

    // Comparison to decimal ------------------------------------------------ /

    /**
     Compares a percent and a percent expressed as a decimal
     - Parameter lhs: A percent to compare
     - Parameter rhs: A percent expressed as a decimal
     - Returns: If comparison was successful
     */
    public static func < (lhs: Self, rhs: ExpressedAsDecimal) -> Bool {
        lhs.decimal < rhs
    }

    /**
     Compares a percent and a percent expressed as a decimal
     - Parameter lhs: A percent expressed as a decimal
     - Parameter rhs: A percent to compare
     - Returns: If comparison was successful
     */
    public static func < (lhs: ExpressedAsDecimal, rhs: Self) -> Bool {
        lhs < rhs.decimal
    }

    /**
     Compares a percent and a percent expressed as a decimal
     - Parameter lhs: A percent to compare
     - Parameter rhs: A percent expressed as a decimal
     - Returns: If comparison was successful
     */
    public static func > (lhs: Self, rhs: ExpressedAsDecimal) -> Bool {
        lhs.decimal > rhs
    }

    /**
     Compares a percent and a percent expressed as a decimal
     - Parameter lhs: A percent expressed as a decimal
     - Parameter rhs: A percent to compare
     - Returns: If comparison was successful
     */
    public static func > (lhs: ExpressedAsDecimal, rhs: Self) -> Bool {
        lhs > rhs.decimal
    }

    /**
     Compares a percent and a percent expressed as a decimal
     - Parameter lhs: A percent to compare
     - Parameter rhs: A percent expressed as a decimal
     - Returns: If comparison was successful
     */
    public static func <= (lhs: Self, rhs: ExpressedAsDecimal) -> Bool {
        lhs.decimal <= rhs
    }

    /**
     Compares a percent and a percent expressed as a decimal
     - Parameter lhs: A percent expressed as a decimal
     - Parameter rhs: A percent to compare
     - Returns: If comparison was successful
     */
    public static func <= (lhs: ExpressedAsDecimal, rhs: Self) -> Bool {
        lhs <= rhs.decimal
    }

    /**
     Compares a percent and a percent expressed as a decimal
     - Parameter lhs: A percent to compare
     - Parameter rhs: A percent expressed as a decimal
     - Returns: If comparison was successful
     */
    public static func >= (lhs: Self, rhs: ExpressedAsDecimal) -> Bool {
        lhs.decimal >= rhs
    }

    /**
     Compares a percent and a percent expressed as a decimal
     - Parameter lhs: A percent expressed as a decimal
     - Parameter rhs: A percent to compare
     - Returns: If comparison was successful
     */
    public static func >= (lhs: ExpressedAsDecimal, rhs: Self) -> Bool {
        lhs >= rhs.decimal
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
        return Self.init(combined, minimum: lhs.minimum, maximum: lhs.maximum)
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
        return Self.init(difference, minimum: lhs.minimum, maximum: lhs.maximum)
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
        return Self.init(decimal: product, minimum: lhs.minimum, maximum: lhs.maximum)
    }

    /**
     Finds the quotient of two percents.
     For example, 50% / 25% = 2
     - Parameter lhs: A base percent to divide (the new percent will follow the minimum/maximum set on the this percent)
     - Parameter rhs: A percent to divide the first by
     - Returns: A number representing the amount of the right percent that fit into the left percent
     */
    public static func / (lhs: Self, rhs: Self) -> BaseType {
        return lhs.decimal / rhs.decimal
    }

    /**
     Adds the specified percent of a number.
     For example, 50 + 50% = 75
     - Parameter lhs: A number to add to
     - Parameter rhs: A percent representing the percent of the left number to to add to itself
     - Returns: A number that is greater than the left number by the right percent of the left number
     */
    public static func + (lhs: BaseType, rhs: Self) -> BaseType { lhs + (lhs * rhs) }

    /**
     Subtracts the specified percent of a number.
     For example, 50 - 50% = 25
     - Parameter lhs: A number to subtract from
     - Parameter rhs: A percent representing the percent of the left number to to subtract from itself
     - Returns: A number that is less than the left number by the right percent of the left number
     */
    public static func - (lhs: BaseType, rhs: Self) -> BaseType { lhs - (lhs * rhs)  }

    /**
     Multiplies a percent by the the specified number.
     For example, 50% * 2 = 100%
     - Parameter lhs: A percent to multiply
     - Parameter rhs: A number to multiply the percent by
     - Returns: A new percent bounded by the minimum/maximum set on the left percent
     */
    public static func * (lhs: Self, rhs: BaseType) -> Self {
        let product = lhs.decimal * rhs
        return Self.init(product, minimum: lhs.minimum, maximum: lhs.maximum)
    }

    /**
     Multiplies a number by the the specified percent (In other words, multiplies by the decimal).
     For example, 50 * 50% = 25
     - Parameter lhs: A number to multiply
     - Parameter rhs: A percent to multiply the number by
     - Returns: A number representing the  product of the left and decimal of the right
     */
    public static func * (lhs: BaseType, rhs: Self) -> BaseType {
        lhs * rhs.decimal
    }

    /**
     Divides a number by the the specified percent (In other words, divided by the decimal).
     For example, 50 / 50% = 100
     - Parameter lhs: A number to divide
     - Parameter rhs: A percent to divide the number by
     - Returns: A number representing the  quotient of the left and decimal of the right
     */
    public static func / (lhs: BaseType, rhs: Self) -> BaseType {
        lhs / rhs.decimal
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
        return Self.init(quotient, minimum: lhs.minimum, maximum: lhs.maximum)
    }
}


