//
//  PercentInputProtocol.swift
//  
//
//  Created by Justin Reusch on 6/23/20.
//

import Foundation

/// A floating-point number that expresses a percentage as an amount over 100.
/// For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
public protocol PercentFloatingPoint: FloatingPoint {
    
    /// A type alias for same type but represented as a decimal instead of percent
    associatedtype DecimalEquivalent where DecimalEquivalent == Self
    
    /// The percent as a decimal (out of 1 rather than out of 100)
    var decimal: DecimalEquivalent { get }
    
    /// The percent gap to 100 (full)
    var toOneHundred: Self { get }
    
    /// Cleans any unnecessary trailing zeros for output formatting
    /// For example, 50.0 -> 50, but 50.3 -> 50.3
    var removeTrailingZeros: String { get }
}


/// Default implementations
extension PercentFloatingPoint {
    
    /// The percent as a decimal (out of 1 rather than out of 100)
    public var decimal: DecimalEquivalent { self / 100 }
    
    /// The percent gap to 100 (full)
    public var toOneHundred: Self { 100 - self }
}

// ------------------------------------------------------------------ /

/// A floating-point number that expresses a percentage as a decimal.
/// For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
public protocol DecimalFloatingPoint: FloatingPoint {
    
    /// A type alias for same type but represented as a percent instead of decimal
    associatedtype PercentEquivalent where PercentEquivalent == Self
    
    /// The decimal as a percent (out of 100 rather than out of 1)
    var percent: PercentEquivalent { get }
    
    /// The decimal gap to 1 (full)
    var toOne: Self { get }
}

/// Default implementations
extension DecimalFloatingPoint {
    
    /// The decimal as a percent (out of 100 rather than out of 1)
    public var percent: PercentEquivalent { self * 100 }
    
    /// The decimal gap to 1 (full)
    public var toOne: Self { 1 - self }
}
