//
//  PercentProtocol.swift
//
//
//  Created by Justin Reusch on 6/20/20.
//

import Foundation

public protocol PercentInput: FloatingPoint {
    
    associatedtype DecimalEquivalent where DecimalEquivalent == Self
    
    var percentDecimal: DecimalEquivalent { get }
    var toFull: Self { get }
    var ofFull: DecimalEquivalent { get }
    var clean: String { get }
    static var empty: Self { get }
    static var full: Self { get }
}

extension PercentInput {
    public var percentDecimal: DecimalEquivalent { self / 100 }
    public var toFull: Self { Self.full - self }
    public var ofFull: DecimalEquivalent { self / Self.full }
}

public protocol PercentDecimalInput: FloatingPoint {
    
    associatedtype PercentEquivalent where PercentEquivalent == Self
    
    var percentValue: PercentEquivalent { get }
    var toFullDecimal: Self { get }
    static var emptyDecimal: Self { get }
    static var fullDecimal: Self { get }
}

extension PercentDecimalInput {
    public var percentValue: PercentEquivalent { self * 100 }
    public var toFullDecimal: Self { Self.fullDecimal - self }
}

/// Holds a percentage as a value
public protocol PercentProtocol: CustomStringConvertible, Hashable, Comparable {
    
    associatedtype PercentType: FloatingPoint
    associatedtype ExpressedAsPercent where ExpressedAsPercent == PercentType
    associatedtype ExpressedAsDecimal where ExpressedAsDecimal == PercentType
    
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
    init(_ numerator: PercentType, over denominator: PercentType, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    init(_ numerator: Int, over denominator: Int, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    init(oneOver denominator: PercentType, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    init(oneOver denominator: Int, minimum: ExpressedAsPercent?, maximum: ExpressedAsPercent?)
    
    // 🛠 Methods ------------------------------------------------ /
    
    /**
     Applies the percentage to a number to get the percentage of that number
     - Parameter number: The number to get  a percentage of
     */
    func of(number: PercentType) -> PercentType
    
    /**
     Applies the percentage to a number to get the percentage of that number
     - Parameter number: The number to get  a percentage of
     */
    func of(number: Int) -> PercentType
}

// 🛠 Methods ------------------------------------------------ /

extension PercentProtocol {
    
    /**
     Applies the percentage to a number to get the percentage of that number
     - Parameter number: The number to get  a percentage of
     */
    public func of(number: PercentType) -> PercentType { number * decimal }
    
    /**
     Applies the percentage to a number to get the percentage of that number
     - Parameter number: The number to get  a percentage of
     */
    public func of(number: Int) -> PercentType { PercentType.init(number) * decimal }
}

extension PercentProtocol {

    /// Checks equality
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.percent == rhs.percent
    }

    // Checks equality with decimal ------------------------------------------------ /

    /// Compares a percent and double
    public static func == (lhs: Self, rhs: ExpressedAsPercent) -> Bool {
        lhs.decimal == rhs
    }
}

extension PercentProtocol {

    /// Compares to another percent
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.percent < rhs.percent
    }

    // Comparison to decimal ------------------------------------------------ /

    /// Compares a percent and double
    public static func < (lhs: Self, rhs: ExpressedAsDecimal) -> Bool {
        lhs.decimal < rhs
    }

    /// Compares a percent and double
    public static func < (lhs: ExpressedAsDecimal, rhs: Self) -> Bool {
        lhs < rhs.decimal
    }

    /// Compares a percent and double
    public static func > (lhs: Self, rhs: ExpressedAsDecimal) -> Bool {
        lhs.decimal > rhs
    }

    /// Compares a percent and double
    public static func > (lhs: ExpressedAsDecimal, rhs: Self) -> Bool {
        lhs > rhs.decimal
    }

    /// Compares a percent and double
    public static func <= (lhs: Self, rhs: ExpressedAsDecimal) -> Bool {
        lhs.decimal <= rhs
    }

    /// Compares a percent and double
    public static func <= (lhs: ExpressedAsDecimal, rhs: Self) -> Bool {
        lhs <= rhs.decimal
    }

    /// Compares a percent and double
    public static func >= (lhs: Self, rhs: ExpressedAsDecimal) -> Bool {
        lhs.decimal >= rhs
    }

    /// Compares a percent and double
    public static func >= (lhs: ExpressedAsDecimal, rhs: Self) -> Bool {
        lhs >= rhs.decimal
    }

    // ➕➖✖️➗ Arithmetic ------------------------------------------------ /

    /// Adds to percents together
    public static func + (lhs: Self, rhs: Self) -> Self {
        let combined = lhs.percent + rhs.percent
        return Self.init(combined, minimum: lhs.minimum, maximum: lhs.maximum)
    }

    /// Finds the difference of two percents
    public static func - (lhs: Self, rhs: Self) -> Self {
        let difference = lhs.percent - rhs.percent
        return Self.init(difference, minimum: lhs.minimum, maximum: lhs.maximum)
    }

    /// Finds the product of two percents
    public static func * (lhs: Self, rhs: Self) -> Self {
        let product = lhs.decimal * rhs.decimal
        return Self.init(decimal: product, minimum: lhs.minimum, maximum: lhs.maximum)
    }

    /// Finds the quotient of two percents
    public static func / (lhs: Self, rhs: Self) -> Self {
        let quotient = lhs.decimal / rhs.decimal
        return Self.init(decimal: quotient, minimum: lhs.minimum, maximum: lhs.maximum)
    }

    /// Adds the specified percent of a double
    public static func + (lhs: PercentType, rhs: Self) -> PercentType { lhs + (lhs * rhs) }

    /// Subtracts the specified percent of a double
    public static func - (lhs: PercentType, rhs: Self) -> PercentType { lhs - (lhs * rhs)  }

    /// Finds the product of a percent and double
    public static func * (lhs: Self, rhs: PercentType) -> PercentType { limit(lhs.decimal * rhs, minimum: lhs.minimum, maximum: lhs.maximum) }

    /// Finds the product of a percent and double
    public static func * (lhs: PercentType, rhs: Self) -> PercentType { rhs.decimal * lhs }

    /// Divides a double by the the specified percent
    public static func / (lhs: PercentType, rhs: Self) -> PercentType { lhs / rhs.decimal }

    /// Divides a percent by the the specified double
    public static func / (lhs: Self, rhs: PercentType) -> Self {
        let quotient = lhs.percent / rhs
        return Self.init(quotient, minimum: lhs.minimum, maximum: lhs.maximum)
    }
}


