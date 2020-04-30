//
//  TotalModel.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

let screen = UIScreen.main.bounds

public enum ItemType: String, Codable {
    case quer = "问卷"
    case vote = "投票"
    case test = "答题"
}

public enum ItemStatus: Int, Codable {
    case notPub = 0
    case pubed = 1
    case overed = 2
    
    func text() -> String {
        switch self {
        case .notPub:
            return "未发布"
        case .pubed:
            return "已发布"
        default:
            return "已过期"
        }
    }
}




extension UIColor {
/**
 The six-digit hexadecimal representation of color of the form #RRGGBB.
 
 - parameter hex6: Six-digit hexadecimal value.
 */
public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
    // TODO: below
    // Store Hex converted UIColours (R, G, B, A) to a persistent file (.plist)
    // And when initializing the app, read from the plist into the memory as a static struct (Metadata.Color)
    let divisor = CGFloat(255)
    let r = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
    let g = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
    let b = CGFloat( hex6 & 0x0000FF       ) / divisor
    self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension UIView {
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

/// its rect will be insert at screen's center
/// - Parameters:
///   - y:
///   - width:
///   - height:
func TRect(y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    let x = (UIScreen.main.bounds.width - width) / 2
    return CGRect(x: x, y: y, width: width, height: height)
}

func TRect(xOffset: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    let x = (UIScreen.main.bounds.width - width) / 2
    return CGRect(x: x + xOffset, y: y, width: width, height: height)
}
