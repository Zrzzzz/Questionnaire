//
//  MyJoinListCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/10.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class MyJoinListCell: UITableViewCell {
    var bgView: UIImageView!
    var title: UILabel!
    var statusBlock: StatusBlock!
    var statusLabel: UILabel!
    var scoreLabel: UILabel!
    var timeLabel: UILabel!
    
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
        
        scoreLabel = UILabel()
        scoreLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        scoreLabel.textColor = TColor.main
        scoreLabel.textAlignment = .center
        contentView.addSubview(scoreLabel)
        scoreLabel.snp.updateConstraints { (make) in
            make.centerX.equalTo(countCenterX)
            make.centerY.equalTo(frame.height / 3)
        }
        
        timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = .systemGray
        timeLabel.textAlignment = .right
        timeLabel.text = "问卷数量"
        contentView.addSubview(timeLabel)
        timeLabel.snp.updateConstraints { (make) in
            make.width.equalTo(frame.width / 2)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.centerY.equalTo(frame.height / 3 * 2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(paper: MyJoinPaper) {
        title.text = paper.paperName
        statusBlock.changeStatus(status: paper.status)
        
        if !contentView.subviews.contains(scoreLabel) {
            scoreLabel.addSubview(scoreLabel)
        }
        switch paper.score {
        case -1:
            scoreLabel.text = "待批阅"
            scoreLabel.textColor = .systemGray
        case -2:
            scoreLabel.removeFromSuperview()
        default:
            scoreLabel.text = paper.score?.description
            scoreLabel.textColor = TColor.main
        }
        
        let timeInterval = TimeInterval(paper.lastTime ?? 0)
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        timeLabel.text = formatter.string(from: date)
    }
    
}

