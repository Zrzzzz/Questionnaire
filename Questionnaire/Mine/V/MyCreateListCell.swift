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
    var starView: UIImageView!
    
    var line: CAShapeLayer!
    
    let lOffset: CGFloat = screen.width / 10
    let lineX: CGFloat = screen.width * 0.75
    let countCenterX = screen.width * 0.85
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Cell高度
        frame = CGRect(x: 0, y: 0, width: screen.width, height: 180)
        // Cell背景颜色
        backgroundColor = TColor.bgGray
        
        // 背景图
        bgView = UIImageView(frame: CGRect(x: frame.minX + frame.width * 0.05, y: frame.minY + frame.height * 0.1, width: frame.width * 0.9, height: frame.height * 0.8))
        bgView.backgroundColor = TColor.bgWhite
        bgView.setCornerRadius(radius: 5)
        contentView.addSubview(bgView)
        
        title = UILabel()
        title.font = .systemFont(ofSize: 20, weight: .bold)
        contentView.addSubview(title)
        title.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(lOffset)
            make.centerY.equalTo(frame.height * 0.4)
        }
        
        statusBlock = StatusBlock(frame: CGRect(x: lOffset, y: frame.height / 2, width: frame.width, height: frame.height / 4), status: PaperStatus.notPub)
        contentView.addSubview(statusBlock)
        
        line = LineMake(color: TColor.main, lineWidth: 1.5, points: CGPoint(x: lineX, y: 45), CGPoint(x: lineX, y: frame.height - 45))
        contentView.layer.addSublayer(line)
        
        countLabel = UILabel()
        countLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        countLabel.textColor = TColor.main
        contentView.addSubview(countLabel)
        countLabel.snp.updateConstraints { (make) in
            make.centerX.equalTo(countCenterX)
            make.centerY.equalTo(frame.height * 0.4)
        }
        
        countText = UILabel()
        countText.font = .systemFont(ofSize: 14, weight: .regular)
        countText.textColor = TColor.textGray
        countText.text = "问卷数量"
        contentView.addSubview(countText)
        countText.snp.updateConstraints { (make) in
            make.centerX.equalTo(countCenterX)
            make.centerY.equalTo(frame.height / 3 * 2)
        }
        
        starView = UIImageView()
        starView.contentMode = .scaleAspectFill
        contentView.addSubview(starView)
        starView.snp.updateConstraints { (make) in
            make.width.height.equalTo(screen.width / 20)
            make.centerX.equalTo(screen.width / 10 * 7)
            make.centerY.equalTo(countText)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(paper: MyCreatePaper) {
        title.text = paper.paperName
        statusBlock.changeStatus(status: paper.status)
        countLabel.text = String(describing: paper.number)
        
        starView.image = UIImage(named: paper.star == 1 ? "star" : "unstar")
    }
    
}

