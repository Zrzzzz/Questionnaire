//
//  EditQuesCollectionViewCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/19.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

// 问卷题目的Cell
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
            self.removeView(type: oldValue)
            switch quesType {
            case .blank:
                contentView.addSubview(textField)
            case .single, .multiple:
                // 不需要做什么, options会完成
                return
            case .rating:
                return
            }
        }
    }
    
    // single & multiple
    lazy var ansLabels: [UILabel] = []
    
    // blank
    lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 5, y: 40, width: self.frame.width * 0.8, height: 30))
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
//    rating, 因为这个每次样式不同, 所以得之后设定
    var ratingView: RatingView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.setCornerRadius(radius: 5)
        // 题目
        quesLabel = UILabel(frame: CGRect(x: 5, y: 5, width: frame.width * 0.8, height: 30))
        contentView.addSubview(quesLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update<T>(by ques: T, row: Int) {
        switch ques {
        case let single as Single:
            quesType = .single
            quesLabel.attributedText = attrString(from: single.question, score: single.score, row: row)
            options = single.options
            
        case let multi as Multiple:
            quesType = .multiple
            quesLabel.attributedText = attrString(from: multi.question, score: multi.score, row: row)
            options = multi.options
            
        case let blank as Blank:
            quesType = .blank
            quesLabel.attributedText = attrString(from: blank.question, score: blank.score, row: row)
//        case let rating as Rating:
            
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
    
    private func removeView(type: QuesType) {
        switch type {
        case .single, .multiple:
            for label in ansLabels {
                label.removeFromSuperview()
            }
            ansLabels.removeAll()
        case .blank:
            textField.removeFromSuperview()
        case .rating:
            ratingView.removeFromSuperview()
        }
    }
    
    private func attrString(from oriStr: String, score: Int, row: Int) -> NSMutableAttributedString {
        let scoreStr = "(\(score)分)"
        let str = "\(row). " + oriStr + scoreStr
        let attrStr = NSMutableAttributedString(string: str)
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], range: NSRange(location: 0, length: str.count - scoreStr.count))
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: TColor.textBlue], range: NSRange(location: str.count - scoreStr.count, length: str.count - 3 - oriStr.count))
        
        return attrStr
    }
    
    // estimated itemsize will call this func
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        var estimateHeight = CGFloat(30 + 10) // 这是题目高 + 富余高
        switch quesType {
        case .single, .multiple:
            estimateHeight += CGFloat(options!.count) * 30
        case .blank:
            estimateHeight += 35
        case .rating:
            estimateHeight += 40
        }
        
        autoLayoutAttributes.frame = CGRect(x: autoLayoutAttributes.frame.minX, y: autoLayoutAttributes.frame.minY, width: autoLayoutAttributes.frame.width, height: estimateHeight)
        
        return autoLayoutAttributes
    }
}


