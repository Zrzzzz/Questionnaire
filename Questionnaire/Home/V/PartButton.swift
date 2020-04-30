//
//  PartButton.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import SnapKit

class PartButton: UIButton {
    var label: UILabel!

    convenience init(title: String) {
        self.init()
        self.setCornerRadius(radius: 10)
        backgroundColor = TColor.main
        
        label = UILabel(frame: CGRect.zero)
        label.text = title
        label.sizeToFit()
        
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
}
