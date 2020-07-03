//
//  QuestionCollectionViewCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/31.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class QuestionCollectionViewCell: UICollectionViewCell {
    var bgView: UIView!
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        bgView = UIView()
        contentView.addSubview(bgView)
        bgView.backgroundColor = TColor.bgWhite
        bgView.setCornerRadius(radius: 10)
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = .init(width: 10, height: 10)
        bgView.layer.shadowRadius = 10
        bgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(60)
            make.width.equalTo(screen.width - 30)
        }
        
        textLabel = UILabel()
        contentView.addSubview(textLabel)
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.backgroundColor = TColor.bgWhite
        textLabel.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func update(text: String) {
        if (textLabel != nil) {
            textLabel.text = text
        }
    }
}
