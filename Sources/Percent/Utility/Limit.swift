//
//  Limit.swift
//  
//
//  Created by Justin Reusch on 6/21/20.
//

import Foundation

/**
 Limits a
 */
func limit<T: Comparable>(_ value: T, min: T? = nil, max: T? = nil) -> T {
    return limitToMax(limitToMin(value, min: min), max: max)
}

func limitToMin<T: Comparable>(_ value: T, min: T? = nil) -> T {
    guard let min = min else { return value }
    return max(value, min)
}

func limitToMax<T: Comparable>(_ value: T, max: T? = nil) -> T {
    guard let max = max else { return value }
    return min(value, max)
}
