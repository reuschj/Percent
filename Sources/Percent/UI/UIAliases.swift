//
//  UIAliases.swift
//
//
//  Created by Justin Reusch on 6/20/20.
//

import UIKit

/// A CGFloat that expresses a percentage as an amount over 100.
/// For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
public typealias PercentCGFloat = CGFloat

extension PercentCGFloat: PercentFloatingPoint {
    
    public typealias DecimalEquivalent = DecimalCGFloat
    
    /// Cleans any unnecessary trailing zeros for output formatting
    /// For example, 50.0 -> 50, but 50.3 -> 50.3
    public var removeTrailingZeros: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(Double(self))
    }
}

/// A CGFloat that expresses a percentage as a decimal.
/// For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
public typealias DecimalCGFloat = CGFloat

extension DecimalCGFloat: DecimalFloatingPoint {
    
    public typealias PercentEquivalent = PercentCGFloat
}
