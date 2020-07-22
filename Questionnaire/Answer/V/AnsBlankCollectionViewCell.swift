//
//  AnsBlankCollectionViewCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/22.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class AnsBlankCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    var quesLabel: UILabel!
    var textView: UITextView!
    
    var isAnswered: Bool = false
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.setCornerRadius(radius: 5)
        // 题目
        quesLabel = UILabel(frame: CGRect(x: 5, y: 5, width: frame.width * 0.8, height: 30))
        contentView.addSubview(quesLabel)
        // 文本框
        textView = UITextView(frame: CGRect(x: 5, y: 45, width: frame.width - 10, height: 40))
        contentView.addSubview(textView)
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.setCornerRadius(radius: 5)
        textView.layer.masksToBounds = true
        textView.returnKeyType = .done
        // 防止圆角遮挡
//        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)
        textView.font = .systemFont(ofSize: 18)
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let lineHeight = textView.font?.lineHeight {
            let nowSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: lineHeight))
            let lines = floorf(Float(nowSize.height / lineHeight))
            if lines <= 1 {
                let addedHeight = lineHeight * CGFloat(lines - 1)
//                commentView.snp.updateConstraints { (make) in
//                    make.height.equalTo(70 + addedHeight)
//                    make.top.equalTo(view.snp.bottom).offset(-83 - 90 - addedHeight)
//                }
                textView.frame.size = CGSize(width: textView.frame.width, height: 40 + addedHeight)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(by ques: Blank, row: Int) {
        quesLabel.attributedText = attrString(from: ques.question, score: ques.score, row: row)
    }
    
    
    
    // 返回标题
    private func attrString(from oriStr: String, score: Int, row: Int) -> NSMutableAttributedString {
        let scoreStr = "(\(score)分)"
        let str = "\(row). " + oriStr + scoreStr
        let attrStr = NSMutableAttributedString(string: str)
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], range: NSRange(location: 0, length: str.count - scoreStr.count))
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: TColor.textBlue], range: NSRange(location: str.count - scoreStr.count, length: str.count - 3 - oriStr.count))
        
        return attrStr
    }
    
    // estimated itemsize will call this func
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
    
        let estimateHeight = CGFloat(30 + 20) + textView.frame.height
        
        autoLayoutAttributes.frame = CGRect(x: autoLayoutAttributes.frame.minX, y: autoLayoutAttributes.frame.minY, width: autoLayoutAttributes.frame.width, height: estimateHeight)
        
        return autoLayoutAttributes
    }
}
