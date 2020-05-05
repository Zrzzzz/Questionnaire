//
//  QuerSettingLabel.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/4.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class QuerSettingLabel: UIView {
    var label: UILabel!
    var uiswitch: UISwitch!
    
    let lOffset = screen.width / 8
    
    init(with text: String, frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        label = UILabel()
        label.text = text
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(lOffset)
            make.centerY.equalTo(self)
        }
        
        uiswitch = UISwitch()
        uiswitch.center = CGPoint(x: screen.width / 8 * 7, y: self.frame.height / 2)
        addSubview(uiswitch)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
