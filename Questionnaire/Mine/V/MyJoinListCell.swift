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
    var scoreLabel: UILabel!
    var timeLabel: UILabel!
    var starView: UIImageView!
    
    
    let lOffset: CGFloat = screen.width / 10
    let countCenterX = screen.width * 0.8
    
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
        
        scoreLabel = UILabel()
        scoreLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        scoreLabel.textColor = TColor.main
        scoreLabel.textAlignment = .center
        contentView.addSubview(scoreLabel)
        scoreLabel.snp.updateConstraints { (make) in
            make.centerX.equalTo(countCenterX)
            make.centerY.equalTo(frame.height * 0.4)
        }
        
        timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = TColor.textGray
        timeLabel.textAlignment = .right
        timeLabel.text = "问卷数量"
        contentView.addSubview(timeLabel)
        timeLabel.snp.updateConstraints { (make) in
            make.width.equalTo(frame.width / 2)
            make.right.equalTo(bgView.snp.right).offset(-10)
            make.centerY.equalTo(frame.height / 3 * 2)
        }
        
//        starView = UIImageView()
//        starView.contentMode = .scaleAspectFill
//        contentView.addSubview(starView)
//        starView.snp.updateConstraints { (make) in
//            make.width.height.equalTo(screen.width / 10)
//            make.right.equalTo(timeLabel.snp.left)
//            make.centerY.equalTo(timeLabel)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(paper: MyJoinPaper) {
        // 标题 状态
        title.text = paper.paperName
        statusBlock.changeStatus(status: paper.status)
        // 分数 批阅
        
        switch paper.score {
        case -1:
            scoreLabel.text = "待批阅"
            scoreLabel.textColor = TColor.textGray
        case -2:
            scoreLabel.text = ""
        default:
            scoreLabel.text = paper.score?.description
            scoreLabel.textColor = TColor.main
        }
        
        // 时间
        let timeInterval = TimeInterval(paper.lastTime ?? 0)
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        timeLabel.text = formatter.string(from: date)

        // TODO: 标星
//        starView.image = UIImage(named: paper.)
        
    }
    
}

