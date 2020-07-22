//
//  RatingView.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/19.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class RatingView: UIView {
    enum IconType {
        case circ, star
    }
    var maxCount: Int
    var type: IconType
    var curCount: Int = 0 {
        didSet {
            for i in 0..<maxCount {
                btns[i].setImage(UIImage(named: i <= curCount ? "status_pubed" : "status_notPub"), for: .normal)
            }
        }
    }
    var btns: [UIButton] = []
    
    init(maxCount: Int, type: IconType) {
        self.type = type
        self.maxCount = maxCount
        
        super.init(frame: CGRect.zero)
        
        for i in 0..<maxCount {
            let btn = UIButton()
            btn.setImage(UIImage(named: i == 0 ? "status_pubed" : "status_notPub"), for: .normal)
            btn.tag = i
            btn.addTarget(self, action: #selector(changeCur(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            btns.append(btn)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let btnW = frame.width / CGFloat(maxCount)
        let startX = btnW / 2
        for i in 0..<btns.count {
            let btn = btns[i]
            btn.frame.size = CGSize(width: btnW, height: btnW)
            btn.center = CGPoint(x: startX + CGFloat(i) * btnW, y: frame.height / 2)
        }
        
    }
    
    @objc func changeCur(btn: UIButton) {
        self.curCount = btn.tag
    }
}

