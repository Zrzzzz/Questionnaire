//
//  SelectionView.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/4.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class SelectionView: UIView {
    var btn: UIButton!
    var label: UILabel!
    var isSelected: Bool!
    
    convenience init(with text: String, frame: CGRect) {
        self.init(frame: frame)
        btn = UIButton()
        btn.setImage(SelectionImage(isSelected: false, frame: CGRect(x: 0, y: 0, width: 20, height: 20)).asImage(), for: .normal)
        btn.addTarget(self, action: #selector(btnOnTouched), for: .touchUpInside)
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(frame.height/2)
            make.width.height.equalTo(30)
        }
        
        label = UILabel()
        addSubview(label)
        label.text = text
        label.sizeToFit()
        label.snp.updateConstraints { (make) in
            make.left.equalTo(btn.snp_right).offset(5)
            make.centerY.equalTo(frame.height/2)
        }
        
        isSelected = false
    }
    
    @objc fileprivate func btnOnTouched() {
        isSelected.toggle()
        if isSelected {
            btn.setImage(SelectionImage(isSelected: true, frame: CGRect(x: 0, y: 0, width: 20, height: 20)).asImage(), for: .normal)
        } else {
            btn.setImage(SelectionImage(isSelected: false, frame: CGRect(x: 0, y: 0, width: 20, height: 20)).asImage(), for: .normal)
        }
    }
}

class SelectionImage: UIView {
    var circ: UIView!
    var circArc: CircleArcView!
    
    init(isSelected: Bool, frame: CGRect) {
        super.init(frame: frame)
        circArc = CircleArcView(frame: frame)
        addSubview(circArc)
        
        circ = UIView(frame: CGRect(x: frame.width * 0.2, y: frame.width * 0.2, width: frame.width * 0.6, height: frame.width * 0.6))
        circ.backgroundColor = .black
        circ.setCornerRadius(radius: circ.frame.width / 2)
        if isSelected {
            addSubview(circ)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CircleArcView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置背景色为透明，否则是黑色背景
        self.backgroundColor = UIColor.clear
    }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func draw(_ rect: CGRect) {
        super.draw(rect)
         
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
         
        //创建一个矩形，它的所有边都内缩3
        let drawingRect = self.bounds
         
        //圆弧半径
        let radius = min(drawingRect.width, drawingRect.height)/2 * 0.9
        //圆弧中点
        let center = CGPoint(x:drawingRect.midX, y:drawingRect.midY)
        //绘制圆弧
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        path.lineWidth = 1
        UIColor.black.set()
        //添加路径到图形上下文
        context.addPath(path.cgPath)
        //绘制路径
        context.strokePath()
            
    }
}
