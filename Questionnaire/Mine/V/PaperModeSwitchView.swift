//
//  PaperModeSwitchView.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/12.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class PaperModeSwitchView: UIView {
    var querBtn: UIButton!
    var testBtn: UIButton!
    var voteBtn: UIButton!
    
    var querLabel: UILabel!
    var testLabel: UILabel!
    var voteLabel: UILabel!
    
    let offset: CGFloat = screen.width / 4
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.minX + frame.width * 0.05, y: frame.minY, width: frame.width * 0.9, height: frame.height))
        
        // 背景
        self.backgroundColor = TColor.bgWhite
        self.setCornerRadius(radius: 5)
        
        querBtn = makeBtn(mode: .quer)
        
        testBtn = makeBtn(mode: .test)
        
        voteBtn = makeBtn(mode: .vote)
        
        querLabel = makeLabel(mode: .quer, btn: querBtn)
        
        testLabel = makeLabel(mode: .test, btn: testBtn)
        
        voteLabel = makeLabel(mode: .vote, btn: voteBtn)
        
    }
    
    private func makeBtn(mode: PaperType) -> UIButton {
        let btn = UIButton()
        switch mode {
        case .quer: btn.tag = 0
        case .test: btn.tag = 1
        case .vote: btn.tag = 2
        }
        btn.setImage(UIImage(named: mode.imageName()), for: .normal)
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(70)
            make.centerY.equalTo(frame.height / 2.7)
            switch mode {
            case .quer:
                make.centerX.equalTo(self).offset(-offset)
            case .test:
                make.centerX.equalTo(self)
            case .vote:
                make.centerX.equalTo(self).offset(offset)
            }
            
        }
        
        return btn
    }
    
    private func makeLabel(mode: PaperType, btn: UIButton) -> UILabel {
        let label = UILabel()
        addSubview(label)
        label.text = mode.string()
        label.sizeToFit()
        label.snp.updateConstraints { (make) in
            make.top.equalTo(btn.snp.bottom).offset(5)
            make.centerX.equalTo(btn)
        }
        
        return label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
