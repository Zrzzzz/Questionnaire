//
//  EditPaperCollectionViewCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/19.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

// 这个是问卷标题和说明的Cell
class EditPaperCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var line: CAShapeLayer!
    
    lazy var commentLabel: UILabel? = {
        let label = UILabel(frame: CGRect(x: 5, y: 35, width: self.frame.width * 0.8, height: 20))
        label.font = .systemFont(ofSize: 14)
        label.textColor = TColor.textGray
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        line = LineMake(color: TColor.textGray, lineWidth: 1, points: CGPoint(x: 5, y: frame.height / 2), CGPoint(x: frame.width - 5, y: frame.height / 2))
        contentView.layer.addSublayer(line)
        
        titleLabel = UILabel(frame: CGRect(x: 5, y: 5, width: frame.width * 0.8, height: 20))
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layout = super.preferredLayoutAttributesFitting(layoutAttributes)
        if commentLabel != nil {
            commentLabel?.sizeToFit()
        }
        let esHeight = (commentLabel?.frame.maxY ?? titleLabel.frame.maxY) - titleLabel.frame.minY + 5
        layout.frame = CGRect(x: layout.frame.minX, y: layout.frame.minY, width: layout.frame.width, height: esHeight)
        return layout
    }
}

