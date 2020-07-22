//
//  LoginViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/31.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var imgView = UIImageView()
    var idTF = CenterTF()
    var pwdTF = CenterTF()
    var forgetBtn = UIButton()
    var checkBtn = CenterBtn()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "登录"
        view.backgroundColor = TColor.bgGray
        view.addSubview(imgView)
        view.addSubview(idTF)
        view.addSubview(pwdTF)
        view.addSubview(forgetBtn)
        view.addSubview(checkBtn)
        
        imgView.image = UIImage(named: "twtlogo")
        imgView.snp.makeConstraints { (make) in
            make.height.width.equalTo(150)
            make.centerX.equalTo(view)
            make.top.equalTo(200)
        }
        
        idTF.frame = CGRect(x: 0, y: 400, width: 240, height: 40)
        idTF.placeholder = "请输入学号"
        idTF.keyboardType = .numberPad
        
        pwdTF.frame = CGRect(x: 0, y: 450, width: 240, height: 40)
        pwdTF.placeholder = "请输入密码"
        pwdTF.isSecureTextEntry = true
        
        forgetBtn.setTitle("忘记密码", for: .normal)
        forgetBtn.setTitleColor(TColor.textGray, for: .normal)
        forgetBtn.titleLabel?.font = .systemFont(ofSize: 12)
        forgetBtn.backgroundColor = .clear
        forgetBtn.addTarget(self, action: #selector(forget), for: .touchUpInside)
        
        forgetBtn.snp.updateConstraints { (make) in
            make.width.equalTo(50)
            make.right.equalTo(pwdTF.snp_right).offset(0)
            make.top.equalTo(pwdTF.snp_bottom)
        }
        
        checkBtn.setTitle("登录", for: .normal)
        checkBtn.backgroundColor = TColor.main
        checkBtn.addTarget(self, action: #selector(check), for: .touchUpInside)
        
        checkBtn.snp.updateConstraints { (make) in
            make.width.equalTo(100)
            make.centerY.equalTo(pwdTF.snp_bottom).offset(50)
        }
    }
    
    @objc fileprivate func forget() {
        print("忘记密码")
    }
    
    @objc fileprivate func check() {
        PaperManager.setDefaultRealmForUser(username: "ZZX")
        navigationController?.popViewController(animated: true)
    }
    
}
