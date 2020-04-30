//
//  QuerEditViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/30.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class QuerEditViewController: UIViewController {
    var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
}

//MARK: - UI
extension QuerEditViewController {
    private func setUp() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "编辑问卷"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(setting))
        
        tabBar = UITabBar()
        
    }
}

//MARK: - 按钮方法
extension QuerEditViewController {
    @objc private func setting() {
        let querSetVC = QuerSettingViewController()
        navigationController?.pushViewController(querSetVC, animated: true)
    }
}
