//
//  UIPercentSwiftUI.swift
//  
//
//  Created by Justin Reusch on 6/27/20.
//

import SwiftUI

// Extensions for SwiftUI ----------------------------------------------- /

extension UIPercent {
    
    /**
     Gets a fixed size from passed geometry, based on selected dimension.
     _Note that this will not check the source of the geometry and assumes the geometry is for the container you choose to scale to._
     _Note that this may not be reliable if measuring to `Dimension.other` case,_ in which case it will default to scaling to the minimum of the height and width of the passed container.
     - Parameter geometry: Passed geometry of the container you wish to scale to.
     - Parameter range: A closed range of allowable sizes to constrain to (optional)
     - Returns: A fixed size scaled from the container size
     */
    @available(iOS 13.0, *)
    @available(OSX 10.15, *)
    public func resolve(within geometry: GeometryProxy, limitedTo range: ClosedRange<CGFloat>? = nil) -> CGFloat {
        resolve(within: geometry.size, limitedTo: range)
    }
}
