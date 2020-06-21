//
//  Aliases.swift
//  
//
//  Created by Justin Reusch on 6/20/20.
//

/// A double that expresses a percentage as a while number
/// For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
public typealias PercentValue = Double

extension PercentValue {
    var percentDecimal: PercentDecimal { self / 100 }
    var toFull: PercentValue { Self.full - self }
    var ofFull: PercentDecimal { self / Self.full }
    static let empty: PercentValue = 0
    static let full: PercentValue = 100
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

/// A double that expresses a percentage as a decimal
/// For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
public typealias PercentDecimal = Double

extension PercentDecimal {
    var percentValue: PercentValue { self * 100 }
    var toFullDecimal: PercentDecimal { Self.fullDecimal - self }
    static let emptyDecimal: PercentDecimal = 0
    static let fullDecimal: PercentDecimal = 1
}
