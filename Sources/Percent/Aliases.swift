//
//  Aliases.swift
//  
//
//  Created by Justin Reusch on 6/20/20.
//

/// A double that expresses a percentage as an amount over 100.
/// For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
public typealias PercentDouble = Double

extension PercentDouble: PercentFloatingPoint {
    
    public typealias DecimalEquivalent = DecimalDouble
    
    /// Cleans any unnecessary trailing zeros for output formatting
    /// For example, 50.0 -> 50, but 50.3 -> 50.3
    public var removeTrailingZeros: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

/// A double that expresses a percentage as a decimal.
/// For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
public typealias DecimalDouble = Double

extension DecimalDouble: DecimalFloatingPoint {
    
    public typealias PercentEquivalent = PercentDouble
}
