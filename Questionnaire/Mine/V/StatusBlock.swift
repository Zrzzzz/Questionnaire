//
//  StatusBlock.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/29.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class StatusBlock: UIView {
    // TODO: 合并Status控件
    var statusCirc: StatusCircle!
    var label: UILabel!
    
    convenience init(frame: CGRect, status: PaperStatus) {
        self.init(frame: frame)
        
        let circLength = frame.height * 0.5
        
        statusCirc = StatusCircle(frame: CGRect(x: 0, y: 0, width: circLength, height: frame.height), status: status)
        addSubview(statusCirc)
        
        label = UILabel(frame: CGRect(x: circLength * 1.1, y: 0, width: (frame.width - circLength) * 0.9, height: frame.height))
        addSubview(label)
        label.text = status.string()
    }
    
    convenience init(status: PaperStatus) {
        self.init()
        
        statusCirc = StatusCircle(frame: CGRect.zero, status: status)
        addSubview(statusCirc)
        
        label = UILabel()
        addSubview(label)
        label.text = status.string()
    }
    
//    override func draw(_ rect: CGRect) {
//        statusCirc.frame = CGRect(x: 0, y: 0, width: rect.height, height: rect.height)
//        label.frame = CGRect(x: rect.height * 1.05, y: 0, width: (rect.width - rect.height * 1.05) * 0.95, height: rect.height)
//    }
    
    func changeStatus(status: PaperStatus) {
        statusCirc.changeStatus(status: status)
        label.text = status.string()
    }
    
}
