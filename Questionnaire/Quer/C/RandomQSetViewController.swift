//
//  RandomQSetViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/5.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class RandomQSetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "随机题目"
        
        let checkBtn = UIButton()
        checkBtn.setTitle("确认", for: .normal)
        checkBtn.backgroundColor = TColor.main
        checkBtn.setCornerRadius(radius: 10)
        checkBtn.addTarget(self, action: #selector(ret), for: .touchUpInside)
        view.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(300)
        }
    }
    
    @objc fileprivate func ret() {
        navigationController?.popViewController(animated: true)
    }
}
