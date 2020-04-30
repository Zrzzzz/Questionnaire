//
//  HomeViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
//    // 控件
//    var newQuerBtn: PartButton!
//    var newVoteBtn: PartButton!
//    var newTestBtn: PartButton!
//    var myCreateBtn: PartButton!
//    var myJoinedBtn: PartButton!
//    var trashBtn: PartButton!
    // 变量
    let btnWidth = (screen.width - 100) / 2
    let btnNames = ["新建问卷", "新建投票", "新建答题", "我创建的", "我参与的", "回收站"]
    var btns: [PartButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }

}

//MARK: - UI
extension HomeViewController {
    
    public func setUp() {
        
        navigationItem.title = "问卷答题投票"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(sideListOnTouch))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        for i in 0..<btnNames.count {
            let btn = PartButton(title: btnNames[i])
            btn.tag = i
            view.addSubview(btn)
            btns.append(btn)
            btn.addTarget(self, action: #selector(jumpToNewPage(btn:)), for: .touchUpInside)
            
            btn.snp.makeConstraints { (make) in
                make.width.height.equalTo(btnWidth)
                if (i & 1 == 1) {
                    make.right.equalTo(view.snp.right).offset(-30)
                } else {
                    make.left.equalTo(view.snp.left).offset(30)
                }
                make.top.equalTo(view.snp.top).offset(100 + floor(CGFloat(i / 2)) * (btnWidth + 20))
            }
        }
        
        
    }
    
    
}

//MARK: - Select Method
extension HomeViewController {
    @objc func sideListOnTouch() {
        print("侧边栏")
    }
    
    @objc func jumpToNewPage(btn: PartButton) {
        switch btn.tag {
        case 0:
            let createVC = CreateViewController()
            createVC.type = .quer
            navigationController?.pushViewController(createVC, animated: true)
        case 1:
            let createVC = CreateViewController()
            createVC.type = .vote
            navigationController?.pushViewController(createVC, animated: true)
        case 2:
            let createVC = CreateViewController()
            createVC.type = .test
            navigationController?.pushViewController(createVC, animated: true)
        case 3:
            let mineVC = MineViewController()
            mineVC.navigationItem.title = btn.label?.text!
            navigationController?.pushViewController(mineVC, animated: true)
        default:
            return
        }
    }
}
