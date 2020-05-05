//
//  TotalFunc.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/5.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit


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
