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
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }

}




extension UIButton {
    enum ButtonLayout {
        case leftImage
        case rightImage
        case topImage
        case bottomImage
    }
//    Btn图片与文字并存
    func setLayoutType(type: ButtonLayout){
        let image: UIImage? = self.imageView?.image
        switch type {
        case .leftImage:
            print("系统默认的方式")
        case .rightImage:
            self.imageEdgeInsets = UIEdgeInsets(top:0, left: (self.titleLabel?.frame.size.width)!, bottom: 0, right:-(self.titleLabel?.frame.size.width)!)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(image?.size.width)!, bottom: 0, right: (image?.size.width)!)
        case .topImage:
            self.imageEdgeInsets = UIEdgeInsets(top:-(self.titleLabel?.frame.size.height)!, left: 0, bottom: 0, right:-((self.titleLabel?.frame.size.width)!))
            //图片距离右边框距离减少图片的宽度，距离上m边距的距离减少文字的高度
            self.titleEdgeInsets = UIEdgeInsets(top: ((image?.size.height)!), left: -((image?.size.width)!), bottom: 0, right:0)
        //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        default:
            self.imageEdgeInsets = UIEdgeInsets(top: (self.titleLabel?.frame.size.height)!, left:0, bottom: 0, right:-((self.titleLabel?.frame.size.width)!))
            //图片距离上边距增加文字的高度  距离右边距减少文字的宽度
            self.titleEdgeInsets = UIEdgeInsets(top: -(image?.size.height)!, left: -(image?.size.width)!, bottom: 0, right: 0)
        }
    }
}
