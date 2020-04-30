//
//  StatusCircle.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class StatusCircle: UIView {
    private var colorCirc: UIView!
    convenience init(width: CGFloat, status: ItemStatus) {
        self.init()
        
        frame = CGRect(x: 0, y: 0, width: width, height: width)
        let whiteCirc = UIView(frame: frame)
        whiteCirc.setCornerRadius(radius: whiteCirc.frame.width / 2)
        whiteCirc.backgroundColor = TColor.circ
        addSubview(whiteCirc)
        colorCirc = UIView()
        colorCirc.backgroundColor = UIColor { _ in
            switch status {
            case .notPub:
                return UIColor(hex6: 0xaaaaaa)
            case .pubed:
                return UIColor(hex6:
                    0x56bd77)
            default:
                return UIColor(hex6: 0xe99d42)
            }
        }
        whiteCirc.addSubview(colorCirc)
        colorCirc.snp.makeConstraints { (make) in
            make.width.height.equalTo(width * 0.75)
            make.center.equalTo(whiteCirc)
        }
        colorCirc.setCornerRadius(radius: frame.width * 0.75 / 2)
    }
    
    func changeStatus(status: ItemStatus) {
        colorCirc.backgroundColor = UIColor { _ in
            switch status {
            case .notPub:
                return UIColor(hex6: 0xaaaaaa)
            case .pubed:
                return UIColor(hex6:
                    0x56bd77)
            default:
                return UIColor(hex6: 0xe99d42)
            }
        }
    }
    
}
