//
//  UIPercent.swift
//  
//
//  Created by Justin Reusch on 6/22/20.
//

import SwiftUI

/// Holds a scale for a UI element to set size dynamically based on the size of it's container
struct UIPercent {
    
    /// Private backing value for the percent property
    private var percentValue: CGFloat
    
    /// Percent represented as an amount over 100. For example, 100.0 = 100%, 50.0 = 50%, 1 = 1%, etc.
    public var percent: CGFloat {
        get { percentValue }
        set { percentValue = limit(newValue, minimum: minimum, maximum: maximum) }
    }
    
    /// Percent represented as a decimal. For example, 1.0 = 100%, 0.5 = 50%, 0.01 = 1%, etc.
    public var decimal: CGFloat {
        get { percent / 100 }
        set { percent = newValue * 100 }
    }
    
    /// The minimum percentage that can be stored (Optional)
    public var minimum: CGFloat? = nil
    
    /// The maximum percentage that can be stored (Optional)
    public var maximum: CGFloat? = nil
    
    /// Selects the container to scale to
    var scaleTo: ScaleBase = .screenWidth
    
    /// If for a font, gets the flex font size
    var flexFont: FlexFont { FlexFont(flexFontSize) }
    var flexFontSize: FlexFontSize { decimal * 100 }
    
    // Initializers ---------------------------- /
    
//    /**
//     Inits with percentage and scale
//     - Parameter decimal: Percentage of the container to fill (1 = 100%, 0.5 = 50%)
//     - Parameter scaleBase: Selects the container to scale to
//     */
//    init(_ percent: Percent = Percent(100), of scaleBase: ScaleBase = .screenWidth) {
//        self.percent = percent
//        self.scaleTo = scaleBase
//    }
    
    /**
     Inits with percentage and scale
     - Parameter decimal: Percentage of the container to fill (1 = 100%, 0.5 = 50%)
     - Parameter scaleBase: Selects the container to scale to
     */
    init(_ value: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
        self.percentValue = value
        self.scaleTo = scaleBase
    }
    
    /**
     Inits with percentage and scale
     - Parameter denominator: Denominator of fractional amount of the container to fill (1 = 1/1 = 100%, 2 = 1/2 = 50%, 4 = 1/4 = 25%, etc.)
     - Parameter scaleBase: Selects the container to scale to
     */
    init(oneOver denominator: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
        let decimal: CGFloat = 1 / denominator
        self.init(decimal, of: scaleBase)
    }
    
//    /**
//     Inits with percentage and scale
//     - Parameter decimal: Percentage of the container to fill (1 = 100%, 0.5 = 50%)
//     - Parameter scaleBase: Selects the container to scale to
//     */
//    init(_ percent: Percent = Percent(100), of scaleBase: ScaleBase = .screenWidth) {
//        self.percent = percent
//        self.scaleTo = scaleBase
//    }
//
//    /**
//     Inits with percentage and scale
//     - Parameter decimal: Percentage of the container to fill (1 = 100%, 0.5 = 50%)
//     - Parameter scaleBase: Selects the container to scale to
//     */
//    init(_ decimal: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
//        self.decimal = decimal
//        self.scaleTo = scaleBase
//    }
//
//    /**
//     Inits with percentage and scale
//     - Parameter denominator: Denominator of fractional amount of the container to fill (1 = 1/1 = 100%, 2 = 1/2 = 50%, 4 = 1/4 = 25%, etc.)
//     - Parameter scaleBase: Selects the container to scale to
//     */
//    init(oneOver denominator: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
//        let decimal: CGFloat = 1 / denominator
//        self.init(decimal, of: scaleBase)
//    }
//
    /**
     Inits with a `FlexFont`
     - Parameter flexFont: A font size that is scaled based on it's container.Denominator of fractional amount of the container to fill (1 = 1/1 = 100%, 2 = 1/2 = 50%, 4 = 1/4 = 25%, etc.)
     - Parameter scaleBase: Selects the container to scale to
     */
    init(flexFont: FlexFont, of scaleBase: ScaleBase = .screenWidth) {
        self.init(flexFont.percent, of: scaleBase)
    }
    
    /**
     Inits with a `FlexFontSize`
     - Parameter fontSize: A font size that is scaled based on it's container. Should read as a full number percentage (of 100) of font height the overall container. (10 = 10%)
     - Parameter scaleBase: Selects the container to scale to
     */
    init(fontSize: FlexFontSize, of scaleBase: ScaleBase = .screenWidth) {
        self.init((fontSize / 100), of: scaleBase)
    }
    
    // Methods ---------------------------- /
    
    /**
     Gets the fixed size from the scale within a given container
     - Parameter containerSize: The container size (just the relevant dimension, height or width)
     - Parameter range: A closed range of allowable sizes to constrain to (optional)
     */
    func getSize(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> CGFloat {
        let scaled = containerSize * decimal
        guard let range = range else { return scaled }
        if range.contains(scaled) { return scaled }
        if scaled > range.upperBound { return range.upperBound }
        if scaled < range.upperBound { return range.lowerBound }
        return scaled
    }
    
    /// Enum of containers within the app to scale to
    enum ScaleBase {
        case screenWidth
        case screenHeight
        case clockDiameter
        case clockRadius
        case container(String)
    }
    
    /// A font size that is scaled based on it's container. Should read as a full number percentage (of 100) of font height the overall container. (10 = 10%)
    typealias FlexFontSize = CGFloat
    
    /// A font size that is scaled based on it's container.
    struct FlexFont {
        
        /// A font size that is scaled based on it's container. Should read as a full number percentage (of 100) of font height the overall container. (10 = 10%)
        var size: FlexFontSize = 10
        
        /// Calculated `FlexFontSize` as a percentage of 1, rather than 100
        var percent: CGFloat { size / 100 }
        
        // Initializer ---------------------------- /
        
        /**
         - Parameter size: A font size that is scaled based on it's container. Should read as a full number percentage (of 100) of font height the overall container. (10 = 10%)
         */
        init(_ size: FlexFontSize = 10) {
            self.size = size
        }
    }
}

