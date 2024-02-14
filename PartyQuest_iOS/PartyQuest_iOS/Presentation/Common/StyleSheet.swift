//
//  StyleSheet.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/13.
//

import Foundation
import UIKit

enum PQSize {
    static let buttonHeightRatio = 0.065
}

enum PQColor {
    /// black
    static let text = UIColor.black
    
    /// gray
    static let textGray = UIColor.gray
    
    /// gray
    static let shadow = UIColor.gray.cgColor
    
    /// 9947ff - purple
    static let buttonMain = UIColor(red: 88/255.0,
                                    green: 101/255.0,
                                    blue: 242/255.0,
                                    alpha: 1.0)
    /// AC9FF0 - light purple
    static let buttonSub = UIColor(red: 197/255.0,
                                   green: 156/255.0,
                                   blue: 251/255.0,
                                   alpha: 1.0)
    
    /// 00A32A - green
    static let buttonGreen = UIColor(red: 0.37,
                                     green: 1.63,
                                     blue: 0.42,
                                     alpha: 1)
    
    /// 195B2A - darkGreen
    static let buttonDarkGreen = UIColor(red: 0.25,
                                         green: 0.91,
                                         blue: 0.42,
                                         alpha: 1)
    /// white
    static let white = UIColor.white
    
    /// systemGray6
    static let lightGray = UIColor.systemGray6
    
}

enum PQFont {
    /**
     preferredFont: body,
     size 17
     */
    static let basic = UIFont.preferredFont(forTextStyle: .body)
    
    /**
     preferredFont: headline,
     size: 17
     weight: semibold
     */
    static let basicBold = UIFont.preferredFont(forTextStyle: .headline)
    
    /**
     preferredFont: caption1,
     size: 12
     */
    static let small = UIFont.preferredFont(forTextStyle: .caption1)
    
    /**
     preferredFont: caption2,
     size: 11
     */
    static let xsmall = UIFont.preferredFont(forTextStyle: .caption2)
    
    /**
     preferredFont: large title,
     size: 34
     */
    static let title = UIFont.preferredFont(forTextStyle: .largeTitle)
    
    /**
     preferredFont: title2
     size: 22
     */
    static let subTitle = UIFont.preferredFont(forTextStyle: .title2)
    
    /**
     preferredFont: title3,
     size: 20
     */
    static let cellTitle = UIFont.preferredFont(forTextStyle: .title3)
}

enum PQSpacing {
    /**
     CGFloat: 8
     */
    static let cell = CGFloat(8)
    
    /**
     UIEdgeInsets: 10,10,10,10
     */
    static let margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /**
     CGFloat: 10
     */
    static let side = CGFloat(10)
}
