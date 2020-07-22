//
//  QuestionCollectionViewCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/31.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

// 问卷添加控制中心的Cell
class QuestionCollectionViewCell: UICollectionViewCell {
    
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = TColor.bgWhite
        contentView.setCornerRadius(radius: 10)

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
    
    func update(text: String) {
        if (textLabel != nil) {
            textLabel.text = text
        }
    }
}

