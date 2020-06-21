//
//  Percent.swift
//
//
//  Created by Justin Reusch on 6/20/20.
//

import Foundation

public struct Percent: CustomStringConvertible {
    private var percentValue: PercentValue
    public var percent: PercentValue {
        get { percentValue }
        set { percentValue = limit(newValue, min: min, max: max) }
    }
    public var decimal: PercentDecimal {
        get { percent.percentDecimal }
        set { percent = newValue.percentValue }
    }
    public var min: PercentValue?
    public var max: PercentValue?
    
    init(_ value: PercentValue, min: PercentValue? = nil, max: PercentValue? = nil) {
        self.min = min
        self.max = max
        self.percentValue = limit(value, min: min, max: max)
    }
    
    init(decimal: PercentValue, min: PercentValue? = nil, max: PercentValue? = nil) {
        self.init(decimal.percentValue, min: min, max: max)
    }
    
    init?(string: String, min: PercentValue? = nil, max: PercentValue? = nil) {
        guard let value = Self.getValueOfStringPercent(string) else { return nil }
        self.init(value, min: min, max: max)
    }
    
    init(numerator: Double, denominator: Double, min: PercentValue? = nil, max: PercentValue? = nil) {
        self.init(decimal: (numerator / denominator), min: min, max: max)
    }
    
    init(numerator: Int, denominator: Int, min: PercentValue? = nil, max: PercentValue? = nil) {
        self.init(numerator: Double(numerator), denominator: Double(denominator), min: min, max: max)
    }
    
    /**
     Applies the percentage to a number to get the percentage of that number
     - Parameter number: The number to get  a percentage of
     */
    func of(number: Double) -> Double { number * decimal }
    
    /**
     Applies the percentage to a number to get the percentage of that number
     - Parameter number: The number to get  a percentage of
     */
    func of(number: Int) -> Double { Double(number) * decimal }
    
    public var description: String { Self.toStringPercent(value: percent) }
    
    /**
     Converts a sting percentage to percent value
     - Parameter stringPercent: A percent represented as a string with % at the end (like "100%", "50%", or "25.2%")
     */
    public static func getValueOfStringPercent(_ stringPercent: String) -> PercentValue? {
        guard stringPercent.last == "%" else {
            return Double(stringPercent)
        }
        let index = stringPercent.index(stringPercent.endIndex, offsetBy: -1)
        let rest = stringPercent[..<index]
        return Double(rest)
    }
    
    /**
     Converts a sting percentage to percent decimal
     - Parameter stringPercent: A percent represented as a string with % at the end (like "100%", "50%", or "25.2%")
     */
    public static func getDecimalOfStringPercent(_ stringPercent: String) -> PercentDecimal? {
        guard let value = Self.getValueOfStringPercent(stringPercent) else { return nil }
        return value.percentDecimal
    }
    
    /**
     Checks if a string can be converted to a percent
     - Parameter value: A percent represented as a string with % at the end (like "100%", "50%", or "25.2%")
     */
    public static func isStringPercent(_ value: String) -> Bool {
        guard let _ = Self.getValueOfStringPercent(value) else { return false }
        return true
    }
    
    /**
     Converts a percent value to string
     - Parameter value: A double that expresses a percentage as a while number. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
     */
    public static func toStringPercent(value: PercentValue) -> String {
        return "\(value.clean)%"
    }
    
    /**
     Converts a percent decimal to string
     - Parameter value: A double that expresses a percentage as a while number. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
     */
    public static func toStringPercent(decimal: PercentDecimal) -> String {
        return "\(decimal.percentValue)%"
    }
}

extension Percent: Hashable {
    
    /// Hash function
    public func hash(into hasher: inout Hasher) {
        hasher.combine(percent)
    }
}

extension Percent: Equatable {
    
    /// Checks equality
    public static func == (lhs: Percent, rhs: Percent) -> Bool {
        lhs.percent == rhs.percent
    }
    
    // Checks equality with decimal ------------------------------------------------ /
    
    /// Compares a percent and double
    public static func == (lhs: Percent, rhs: PercentDecimal) -> Bool {
        lhs.decimal == rhs
    }
    
    /// Compares a percent and double
    public static func == (lhs: PercentDecimal, rhs: Percent) -> Bool {
        lhs == rhs.decimal
    }
}

extension Percent: Comparable {
    
    /// Compares to another percent
    public static func < (lhs: Percent, rhs: Percent) -> Bool {
        lhs.percent < rhs.percent
    }
    
    // Comparison to decimal ------------------------------------------------ /
    
    /// Compares a percent and double
    public static func < (lhs: Percent, rhs: PercentDecimal) -> Bool {
        lhs.decimal < rhs
    }
    
    /// Compares a percent and double
    public static func < (lhs: PercentDecimal, rhs: Percent) -> Bool {
        lhs < rhs.decimal
    }
    
    /// Compares a percent and double
    public static func > (lhs: Percent, rhs: PercentDecimal) -> Bool {
        lhs.decimal > rhs
    }
    
    /// Compares a percent and double
    public static func > (lhs: PercentDecimal, rhs: Percent) -> Bool {
        lhs > rhs.decimal
    }
    
    /// Compares a percent and double
    public static func <= (lhs: Percent, rhs: PercentDecimal) -> Bool {
        lhs.decimal <= rhs
    }
    
    /// Compares a percent and double
    public static func <= (lhs: PercentDecimal, rhs: Percent) -> Bool {
        lhs <= rhs.decimal
    }
    
    /// Compares a percent and double
    public static func >= (lhs: Percent, rhs: PercentDecimal) -> Bool {
        lhs.decimal >= rhs
    }
    
    /// Compares a percent and double
    public static func >= (lhs: PercentDecimal, rhs: Percent) -> Bool {
        lhs >= rhs.decimal
    }
    
    // ➕➖✖️➗ Arithmetic ------------------------------------------------ /
    
    /// Adds to percents together
    public static func + (lhs: Percent, rhs: Percent) -> Percent {
        let combined = lhs.percent + rhs.percent
        return Percent(combined, min: lhs.min, max: lhs.max)
    }
    
    /// Finds the difference of two percents
    public static func - (lhs: Percent, rhs: Percent) -> Percent {
        let difference = lhs.percent - rhs.percent
        return Percent(difference, min: lhs.min, max: lhs.max)
    }
    
    /// Finds the product of two percents
    public static func * (lhs: Percent, rhs: Percent) -> Percent {
        let product = lhs.decimal * rhs.decimal
        return Percent(decimal: product, min: lhs.min, max: lhs.max)
    }
    
    /// Finds the quotient of two percents
    public static func / (lhs: Percent, rhs: Percent) -> Percent {
        let quotient = lhs.decimal / rhs.decimal
        return Percent(decimal: quotient, min: lhs.min, max: lhs.max)
    }
    
    /// Adds the specified percent of a double
    public static func + (lhs: Double, rhs: Percent) -> Double { lhs + (lhs * rhs) }
    
    /// Subtracts the specified percent of a double
    public static func - (lhs: Double, rhs: Percent) -> Double { lhs - (lhs * rhs)  }
    
    /// Finds the product of a percent and double
    public static func * (lhs: Percent, rhs: Double) -> Double { limit(lhs.decimal * rhs, min: lhs.min, max: lhs.max) }
    
    /// Finds the product of a percent and double
    public static func * (lhs: Double, rhs: Percent) -> Double { rhs.decimal * lhs }
    
    /// Divides a double by the the specified percent
    public static func / (lhs: Double, rhs: Percent) -> Double { lhs / rhs.decimal }
    
    /// Divides a percent by the the specified double
    public static func / (lhs: Percent, rhs: Double) -> Percent {
        let quotient = lhs.percent / rhs
        return Percent(quotient, min: lhs.min, max: lhs.max)
    }
}


