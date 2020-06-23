//
//  Aliases.swift
//  
//
//  Created by Justin Reusch on 6/20/20.
//

/// A double that expresses a percentage as an amount over 100.
/// For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
public typealias PercentValue = Double

extension PercentValue: PercentInput {
    public typealias DecimalEquivalent = PercentDecimal
    
    public static let empty: PercentValue = 0
    public static let full: PercentValue = 100
    public var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

/// A double that expresses a percentage as a decimal.
/// For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
public typealias PercentDecimal = Double

extension PercentDecimal: PercentDecimalInput {
    public typealias PercentEquivalent = PercentValue
    
    public static let emptyDecimal: PercentDecimal = 0
    public static let fullDecimal: PercentDecimal = 1
}
