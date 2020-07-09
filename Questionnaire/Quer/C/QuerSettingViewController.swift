//
//  QuerSettingViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/30.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class QuerSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = TColor.bgGray
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let label1 = QuerSettingLabel(with: "题目是否乱序", frame: CGRect(x: 0, y: 100, width: screen.width, height: 40))
        view.addSubview(label1)
        
        let label2 = QuerSettingLabel(with: "选项是否乱序", frame: CGRect(x: 0, y: 150, width: screen.width, height: 40))
        view.addSubview(label2)
            
        let label3 = QuerSettingLabel(with: "允许作答次数", frame: CGRect(x: 0, y: 200, width: screen.width, height: 40))
        view.addSubview(label3)
        label3.uiswitch.removeFromSuperview()
        let countTF = UITextField()
        countTF.setCornerRadius(radius: 5)
        countTF.borderStyle = .roundedRect
        countTF.keyboardType = .numberPad
        countTF.placeholder = "1"
        countTF.textAlignment = .center
        label3.addSubview(countTF)
        countTF.snp.makeConstraints { (make) in
            make.centerX.equalTo(screen.width/8*7)
            make.centerY.equalTo(label3)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        let label4 = QuerSettingLabel(with: "随机题目", frame: CGRect(x: 0, y: 250, width: screen.width, height: 40))
        view.addSubview(label4)
        label4.uiswitch.removeFromSuperview()
        let btn = UIButton()
        btn.frame.size = CGSize(width: 150, height: 30)
        btn.setTitle("未设置", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(toRVC), for: .touchUpInside)
        btn.setLayoutType(type: .rightImage)
        label4.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerX.equalTo(screen.width/8*7)
            make.centerY.equalTo(label4)
        }
        
        let checkBtn = UIButton()
        checkBtn.setTitle("确认", for: .normal)
        checkBtn.backgroundColor = TColor.main
        checkBtn.setCornerRadius(radius: 10)
        view.addSubview(checkBtn)
        checkBtn.addTarget(self, action: #selector(ret), for: .touchUpInside)
        checkBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(label4.snp_bottom).offset(20)
        }
        
        
    }
    
    @objc fileprivate func toRVC() {
        let rVC = RandomQSetViewController()
        navigationController?.pushViewController(rVC, animated: true)
    }
    
    @objc fileprivate func ret() {
        navigationController?.popViewController(animated: true)
    }
}


