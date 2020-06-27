//
//  limit.swift
//  
//
//  Created by Justin Reusch on 6/21/20.
//

import Foundation

/**
 Limits a value to a minimum and/or maximum value
 - Parameter value: The value to limit
 - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
 - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
 */
func limit<T: Comparable>(_ value: T, minimum: T? = nil, maximum: T? = nil) -> T {
    return limitToMaximum(limitToMinimum(value, minimum: minimum), maximum: maximum)
}

/**
 Limits a value to a minimum value
 - Parameter value: The value to limit
 - Parameter minimum: The minimum allowed value (omit or pass `nil` for no minimum)
 */
fileprivate func limitToMinimum<T: Comparable>(_ value: T, minimum: T? = nil) -> T {
    guard let min = minimum else { return value }
    return max(value, min)
}

/**
 Limits a value to a maximum value
 - Parameter value: The value to limit
 - Parameter maximum: The maximum allowed value (omit or pass `nil` for no maximum)
 */
fileprivate func limitToMaximum<T: Comparable>(_ value: T, maximum: T? = nil) -> T {
    guard let max = maximum else { return value }
    return min(value, max)
}
