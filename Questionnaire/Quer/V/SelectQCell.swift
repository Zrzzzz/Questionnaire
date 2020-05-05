//
//  SelectQCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/4.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class SelectQCell: UITableViewCell {
    var title: UILabel!
    var ops: [String]!
    
    let lOffset = screen.width / 10
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title = UILabel(frame: CGRect(x: Int(lOffset), y: 0, width: 100, height: 50))
        contentView.addSubview(title)
        title.font = .systemFont(ofSize: 14, weight: .heavy)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for i in 0..<ops.count {
            let label = SelectionView(with: ops[i], frame: CGRect(x: Int(lOffset), y: 50 + 30 * i, width: 100, height: 30))
            
            contentView.addSubview(label)
        }
    }
    
    func set(_ q: QuestionModel) {
        title.text = q.stem
        ops = q.options ?? []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
