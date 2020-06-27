//
//  convertStringPercent.swift
//  
//
//  Created by Justin Reusch on 6/25/20.
//

import Foundation

/**
 Converts a sting percentage to percent value
 - Parameter stringPercent: A percent represented as a string with % at the end (like "100%", "50%", or "25.2%")
 */
func convertStringPercent(_ stringPercent: String) -> Double? {
    guard stringPercent.last == "%" else {
        return Double(stringPercent)
    }
    let index = stringPercent.index(stringPercent.endIndex, offsetBy: -1)
    let rest = stringPercent[..<index]
    return Double(rest)
}
