//
//  TotalView.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class CenterTF: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        圆角
        self.borderStyle = .roundedRect
        
//        文本设置
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
        self.clearButtonMode = .whileEditing
        
//        居中
        let wid = frame.width
        let spaceWid = UIScreen.main.bounds.width
        self.frame.origin.x = (spaceWid - wid) / 2
        
    }
}

class CenterBtn: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        居中
        let wid = frame.width
        let spaceWid = UIScreen.main.bounds.width
        self.frame.origin.x = (spaceWid - wid) / 2
        
//        圆角
        self.setCornerRadius(radius: 14)
    }
}
