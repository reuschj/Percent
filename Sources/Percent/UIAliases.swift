//
//  UIAliases.swift
//
//
//  Created by Justin Reusch on 6/20/20.
//

import UIKit



/// A double that expresses a percentage as an amount over 100.
/// For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
public typealias UIPercentValue = CGFloat

extension UIPercentValue: PercentInput {
    public typealias DecimalEquivalent = UIPercentDecimal
    
    public static let empty: UIPercentValue = 0
    public static let full: UIPercentValue = 100
    public var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(Double(self))
    }
}

/// A double that expresses a percentage as a decimal.
/// For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
public typealias UIPercentDecimal = CGFloat

extension UIPercentDecimal: PercentDecimalInput {
    public typealias PercentEquivalent = UIPercentDecimal
    
    public static let emptyDecimal: UIPercentDecimal = 0
    public static let fullDecimal: UIPercentDecimal = 1
}
