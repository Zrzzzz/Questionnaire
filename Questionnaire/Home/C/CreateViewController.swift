//
//  CreateViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
    // UI控件
    var nameLabel: UILabel!
    var nameTF: UITextField!
    var commentLabel: UILabel!
    var commentTF: UITextField!
    var sTLabel: UILabel!// 开始时间
    var sTTF: UITextField!
    var sTBtn: UIButton!
    var oTLabel: UILabel!// 结束时间
    var oTTF: UITextField!
    var oTBtn: UIButton!
    var createBtn: UIButton!
    
    var pickerView: UIPickerView!
    var pickerCheckBtn: UIButton!
    var cancelBtn: UIButton!
    // 效果控件
    var blurView: UIVisualEffectView!
    var blurEffect: UIBlurEffect!
    // 变量
    var type: ItemType!
    let lOffset = screen.width / 8

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "新建" + type.rawValue
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUp()
    }

}
//MARK: - UI
extension CreateViewController {
    private func setUp() {
        nameLabel = UILabel()
        nameLabel.text = type.rawValue + "名称"
        nameLabel.sizeToFit()
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(lOffset)
            make.top.equalTo(view.snp_top).offset(100)
        }
        
        nameTF = UITextField()
        nameTF.placeholder = "输入" + type.rawValue + "名称"
        nameTF.borderStyle = .roundedRect
        nameTF.adjustsFontSizeToFitWidth = true
        view.addSubview(nameTF)
        nameTF.snp.makeConstraints { (make) in
            make.width.equalTo(screen.width / 2)
            make.left.equalTo(view).offset(lOffset)
            make.top.equalTo(nameLabel.snp_bottom).offset(15)
        }
        
        commentLabel = UILabel()
        commentLabel.text = type.rawValue + "说明"
        commentLabel.sizeToFit()
        view.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(lOffset)
            make.top.equalTo(nameTF.snp_bottom).offset(20)
        }
        
        commentTF = UITextField()
        commentTF.placeholder = "输入" + type.rawValue + "说明"
        commentTF.borderStyle = .roundedRect
        commentTF.adjustsFontSizeToFitWidth = true
        view.addSubview(commentTF)
        commentTF.snp.makeConstraints { (make) in
            make.width.equalTo(screen.width / 2)
            make.left.equalTo(view).offset(lOffset)
            make.top.equalTo(commentLabel.snp_bottom).offset(15)
        }
        
        sTLabel = UILabel()
        sTLabel.text = "开始时间"
        sTLabel.sizeToFit()
        view.addSubview(sTLabel)
        sTLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(lOffset)
            make.top.equalTo(commentTF.snp_bottom).offset(20)
        }
        
        sTTF = UITextField()
        sTTF.placeholder = "1970-1-1"
        sTTF.borderStyle = .roundedRect
        sTTF.adjustsFontSizeToFitWidth = true
        view.addSubview(sTTF)
        sTTF.snp.makeConstraints { (make) in
            make.width.equalTo(screen.width / 2)
            make.left.equalTo(view).offset(lOffset)
            make.top.equalTo(sTLabel.snp_bottom).offset(15)
        }
        
        oTLabel = UILabel()
        oTLabel.text = "结束时间"
        oTLabel.sizeToFit()
        view.addSubview(oTLabel)
        oTLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(lOffset)
            make.top.equalTo(sTTF.snp_bottom).offset(20)
        }
        
        oTTF = UITextField()
        oTTF.placeholder = "1970-1-1"
        oTTF.borderStyle = .roundedRect
        oTTF.adjustsFontSizeToFitWidth = true
        view.addSubview(oTTF)
        oTTF.snp.makeConstraints { (make) in
            make.width.equalTo(screen.width / 2)
            make.left.equalTo(view).offset(lOffset)
            make.top.equalTo(oTLabel.snp_bottom).offset(15)
        }
        
        sTBtn = UIButton()
        sTBtn.tag = 0
        sTBtn.setImage(UIImage(systemName: "text.justify")?.withRenderingMode(.alwaysOriginal), for: .normal)
        sTBtn.addTarget(self, action: #selector(showTimeSelector(btn:)), for: .touchUpInside)
        view.addSubview(sTBtn)
        sTBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(sTTF.snp_height)
            make.centerY.equalTo(sTTF.snp_centerY)
            make.left.equalTo(sTTF.snp_right).offset(10)
        }

        oTBtn = UIButton()
        oTBtn.tag = 1
        oTBtn.setImage(UIImage(systemName: "text.justify")?.withRenderingMode(.alwaysOriginal), for: .normal)
        oTBtn.addTarget(self, action: #selector(showTimeSelector(btn:)), for: .touchUpInside)
        view.addSubview(oTBtn)
        oTBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(oTTF.snp_height)
            make.centerY.equalTo(oTTF.snp_centerY)
            make.left.equalTo(oTTF.snp_right).offset(10)
        }
        
        createBtn = UIButton()
        createBtn.setCornerRadius(radius: 5)
        createBtn.setTitle("创建", for: .normal)
        createBtn.backgroundColor = TColor.main
        createBtn.addTarget(self, action: #selector(create), for: .touchUpInside)
        view.addSubview(createBtn)
        createBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.equalTo(50)
            make.width.equalTo(120)
            make.top.equalTo(oTTF.snp_bottom).offset(50)
        }
    }
}

//MARK: - Select Method
extension CreateViewController {
    @objc private func showTimeSelector(btn: UIButton) {
        let textField = btn.tag == 0 ? sTTF : oTTF
        
        if blurEffect == nil {
            blurEffect = UIBlurEffect(style: .light)
        }
        if blurView == nil {
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        }
        self.view.addSubview(blurView)
        
        if pickerView == nil {
            pickerView = UIPickerView(frame: TRect(y: 200, width: 400, height: 300))
            pickerView.delegate = self
            pickerView.dataSource = self
            blurView.contentView.addSubview(pickerView)
        }
        let time = textField?.text! == "" ? textField?.placeholder! : textField?.text!
        let timeArray = time?.components(separatedBy: "-")
        pickerView.selectRow(Int((timeArray?[0])!)! - 1970, inComponent: 0, animated: true)
        pickerView.selectRow(Int((timeArray?[1])!)! - 1, inComponent: 1, animated: true)
        pickerView.selectRow(Int((timeArray?[2])!)! - 1, inComponent: 2, animated: true)
        
        if pickerCheckBtn == nil {
            pickerCheckBtn = UIButton(frame: TRect(xOffset: 100, y: 550, width: 100, height: 50))
            pickerCheckBtn.setTitle("确认", for: .normal)
            pickerCheckBtn.backgroundColor = .red
            blurView.contentView.addSubview(pickerCheckBtn)
            pickerCheckBtn.addTarget(self, action: #selector(check(btn:)), for: .touchUpInside)
        }
        pickerCheckBtn.tag = btn.tag
        
        if cancelBtn == nil {
            cancelBtn = UIButton(frame: TRect(xOffset: -100, y: 550, width: 100, height: 50))
            cancelBtn.backgroundColor = .red
            cancelBtn.setTitle("取消", for: .normal)
            cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            blurView.contentView.addSubview(cancelBtn)
        }
        
    }
    
    @objc private func check(btn: UIButton) {
        let textField = btn.tag == 0 ? sTTF : oTTF
        
        blurView.removeFromSuperview()
        textField?.text = "\(pickerView.selectedRow(inComponent: 0) + 1970)-\(pickerView.selectedRow(inComponent: 1) + 1)-\(pickerView.selectedRow(inComponent: 2) + 1)"
    }
    
    @objc private func cancel() {
        blurView.removeFromSuperview()
    }
    
    @objc private func create(btn: UIButton) {
        switch btn.tag {
        case 0:
            let editVC = QuerEditViewController()
            navigationController?.pushViewController(editVC, animated: true)
        default:
            return
        }
    }
}

//MARK: - PickerViewDelegate
extension CreateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0:
                return 100
            case 1:
                return 12
            default:
                return 31
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(row + 1970)
        case 1:
            return String(row + 1)
        default:
            return String(row + 1)
        }
    }
}

