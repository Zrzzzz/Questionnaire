//
//  paperListCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class MyCreateListCell: UITableViewCell {
    var bgView: UIImageView!
    var title: UILabel!
    var statusBlock: StatusBlock!
    var statusLabel: UILabel!
    var countLabel: UILabel!
    var countText: UILabel!
    
    var line: CAShapeLayer!
    
    let lOffset: CGFloat = screen.width / 10
    let lineX: CGFloat = screen.width * 0.75
    let countCenterX = screen.width * (1 + 0.75) / 2
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: screen.width, height: 180)
        
        bgView = UIImageView(frame: self.frame)
        bgView.image = UIImage(named: "mycreate_cell_bgview")
        bgView.contentMode = .scaleAspectFit
        contentView.addSubview(bgView)
        
        title = UILabel()
        title.font = .systemFont(ofSize: 20, weight: .bold)
        contentView.addSubview(title)
        title.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(lOffset)
            make.centerY.equalTo(frame.height / 3)
        }
        
        statusBlock = StatusBlock(frame: CGRect(x: lOffset, y: frame.height / 2, width: frame.width, height: frame.height / 4), status: PaperStatus.notPub)
        contentView.addSubview(statusBlock)
        
        line = lineMake(color: TColor.main, lineWidth: 0.8, points: CGPoint(x: lineX, y: 40), CGPoint(x: lineX, y: frame.height - 40))
        contentView.layer.addSublayer(line)
        
        countLabel = UILabel()
        countLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        countLabel.textColor = TColor.main
        contentView.addSubview(countLabel)
        countLabel.snp.updateConstraints { (make) in
            make.centerX.equalTo(countCenterX)
            make.centerY.equalTo(frame.height / 3)
        }
        
        countText = UILabel()
        countText.font = .systemFont(ofSize: 14, weight: .regular)
        countText.textColor = .systemGray
        countText.text = "问卷数量"
        contentView.addSubview(countText)
        countText.snp.updateConstraints { (make) in
            make.centerX.equalTo(countCenterX)
            make.centerY.equalTo(frame.height / 3 * 2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(paper: MyCreatePaper) {
        title.text = paper.paperName
        statusBlock.changeStatus(status: paper.status)
        countLabel.text = String(describing: paper.number)
    }
    
}

