//
//  AnsSingleCollectionViewCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/20.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

// 问卷题目的Cell
class AnsSingleCollectionViewCell: UICollectionViewCell {
    var quesLabel: UILabel!
    
    var isAnswered: Bool = false
    var curSelected: Int = 0 {
        didSet {
            // 是否选择过
            if isAnswered {
                ansBtns[oldValue].setImage(#imageLiteral(resourceName: "answervc_single_off"), for: .normal)
                ansBtns[curSelected].setImage(#imageLiteral(resourceName: "answervc_single_on"), for: .normal)
            } else {
                isAnswered = true
                ansBtns[curSelected].setImage(#imageLiteral(resourceName: "answervc_single_on"), for: .normal)
            }
        }
    }
    
    var options: [String]? {
        didSet {
            for btn in ansBtns {
                btn.removeFromSuperview()
            }
            self.reloadBtns()
            for btn in ansBtns {
                contentView.addSubview(btn)
            }
        }
    }
    
    // single
    var ansBtns: [UIButton] = []

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
    
    func update(by ques: Single, row: Int) {
        quesLabel.attributedText = attrString(from: ques.question, score: ques.score, row: row)
        self.options = ques.options
    }
    
    private func reloadBtns() {
        ansBtns.removeAll()
        var btns = Array<UIButton>()
        for i in 0..<options!.count {
            let btn = UIButton(frame: CGRect(x: 5, y: CGFloat(40 + i * 30), width: self.frame.width * 0.8, height: 30))
            btn.setTitle(options![i], for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.setImage(#imageLiteral(resourceName: "answervc_single_off"), for: .normal)
            btn.contentHorizontalAlignment = .left
            btn.tag = i
            btn.addTarget(self, action: #selector(btnTouched(btn:)), for: .touchUpInside)
            btns.append(btn)
        }
        
        ansBtns = btns
    }
    
    // 点按方法
    @objc private func btnTouched(btn: UIButton) {
        // 改变选项即可
        curSelected = btn.tag
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
        
        let estimateHeight = CGFloat(30 + 10) + CGFloat(options!.count) * 30
        
        autoLayoutAttributes.frame = CGRect(x: autoLayoutAttributes.frame.minX, y: autoLayoutAttributes.frame.minY, width: autoLayoutAttributes.frame.width, height: estimateHeight)
        
        return autoLayoutAttributes
    }
}


