//
//  QuestionCollectionViewCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/31.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

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

class EditPaperCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    lazy var commentLabel: UILabel? = {
        let label = UILabel(frame: CGRect(x: 5, y: 35, width: self.frame.width * 0.8, height: 20))
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
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
        let esHeight = (commentLabel?.frame.maxY ?? titleLabel.frame.maxY) - titleLabel.frame.minY + 25
        layout.frame = CGRect(x: layout.frame.minX, y: layout.frame.minY, width: layout.frame.width, height: esHeight)
        return layout
    }
}

class EditQuesCollectionViewCell: UICollectionViewCell {
    var quesLabel: UILabel!
    var options: [String]? {
        didSet {
            for label in ansLabels {
                label.removeFromSuperview()
            }
            self.reloadLabels()
            for label in ansLabels {
                contentView.addSubview(label)
            }
        }
    }
    var quesType = QuesType.single {
        didSet {
            textField?.removeFromSuperview()
            switch quesType {
            case .blank:
                contentView.addSubview(textField!)
            default:
                return
            }
        }
    }
    
    // it a little bit weird, it will load after options been set
    // not work with dequeueCell
//    var ansLabels: [UILabel] = {
//        var labels = Array<UILabel>()
//        for i in 0..<options!.count {
//            let label = UILabel(frame: CGRect(x: 5.0, y: CGFloat(40 + i * 30), width: self.frame.width * 0.8, height: 30))
//            label.text = options![i]
//            labels.append(label)
//        }
//        return labels
//    }()
    var ansLabels: [UILabel] = []
    
    // blank
    lazy var textField: UITextField? = {
        let textField = UITextField(frame: CGRect(x: 5, y: 40, width: self.frame.width * 0.8, height: 30))
        textField.borderStyle = .roundedRect
        textField.allowsEditingTextAttributes = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.setCornerRadius(radius: 5)
        
        quesLabel = UILabel(frame: CGRect(x: 5, y: 5, width: frame.width * 0.8, height: 30))
        contentView.addSubview(quesLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func draw(_ rect: CGRect) {
//        quesLabel = UILabel(frame: CGRect(x: 5, y: 5, width: frame.width * 0.8, height: 30))
//    }
    
    func update<T>(by ques: T) {
        switch ques {
        case let single as Single:
            quesLabel.text = single.question
            options = single.options
            quesType = .single
        case let multi as Multiple:
            quesLabel.text = multi.question
            options = multi.options
            quesType = .mutliple
        case let blank as Blank:
            quesLabel.text = blank.question
            quesType = .blank
        default:
            return
        }
    }
    
    private func reloadLabels() {
        ansLabels.removeAll()
        var labels = Array<UILabel>()
        for i in 0..<options!.count {
            let label = UILabel(frame: CGRect(x: 5.0, y: CGFloat(40 + i * 30), width: self.frame.width * 0.8, height: 30))
            label.text = options![i]
            labels.append(label)
        }
        ansLabels = labels
    }
    
    // estimated itemsize will call this func
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        var estimateHeight = CGFloat(30 + 10) // 这是题目高 + 富余高
        switch quesType {
        case .single, .mutliple:
            estimateHeight += CGFloat(options!.count) * 30
        case .blank:
            estimateHeight += 35
        }
        
        autoLayoutAttributes.frame = CGRect(x: autoLayoutAttributes.frame.minX, y: autoLayoutAttributes.frame.minY, width: autoLayoutAttributes.frame.width, height: estimateHeight)
        
        return autoLayoutAttributes
    }
}


