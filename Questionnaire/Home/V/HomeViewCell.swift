//
//  HomeViewCell.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/9.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class HomeViewCell: UICollectionViewCell {
    var bgView: UIView!
    var imgView: UIImageView!
    var title: UILabel!
    var arrow: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = TColor.bgGray
        
        bgView = UIView()
        contentView.addSubview(bgView)
        bgView.backgroundColor = TColor.bgWhite
        bgView.setCornerRadius(radius: 10)
        bgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(60)
            make.width.equalTo(screen.width - 30)
        }
        
        imgView = UIImageView()
        bgView.addSubview(imgView)
        imgView.contentMode = .scaleAspectFit
        imgView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(10)
            make.width.height.equalTo(35)
            make.centerY.equalTo(self)
        }
        
        title = UILabel()
        bgView.addSubview(title)
        title.font = .systemFont(ofSize: 16)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp_right).offset(5)
            make.centerY.equalTo(self)
        }
        
        arrow = UIImageView()
        bgView.addSubview(arrow)
        arrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysOriginal)
        arrow.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(bgView.snp_right).offset(-10)
            make.width.height.equalTo(20)
        }
    }
        
    
    
    internal func update(img: UIImage, with title: String, needArrow: Bool) {
        self.imgView.image = img
        self.title.text = title
        if !needArrow { self.arrow.removeFromSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
