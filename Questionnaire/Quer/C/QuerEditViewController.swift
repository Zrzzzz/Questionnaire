//
//  QuerEditViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/30.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class QuerEditViewController: UIViewController {
    // 控件
    var tabBar: UITabBar!
    var tableView: UITableView!
    var newBtn: UIButton!
    
    // 变量
    let quer = Paper()
    let cellid = "Questionnaire.QuerEditVC.cell"
    var data: [Single] = [Single(id: UUID().uuidString, question: "哈哈哈", options: ["nono", "yoyo"], rightAnswer: 0, random: 0, necessary: 0)]
    
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView = UITableView(frame: screen)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        newBtn = UIButton()
        newBtn.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        newBtn.backgroundColor = TColor.main
        newBtn.addTarget(self, action: #selector(toaddQVC), for: .touchUpInside)
        view.addSubview(newBtn)
        newBtn.setCornerRadius(radius: 25)
        newBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(screen.width/5*4)
            make.centerY.equalTo(screen.height/5*4)
            make.height.width.equalTo(50)
        }
    }
}

//MARK: - 按钮方法
extension QuerEditViewController {
    @objc private func setting() {
        let querSetVC = QuerSettingViewController()
        navigationController?.pushViewController(querSetVC, animated: true)
    }
    
    @objc private func toaddQVC() {
        let addQVC = AddQViewController()
        navigationController?.pushViewController(addQVC, animated: true)
    }
}

//MARK: - Delegate
extension QuerEditViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        default:
            return CGFloat(50 + (data[indexPath.row].options.count) * 30)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = quer.paperName
            cell.detailTextLabel?.text = quer.paperComment
            cell.selectionStyle = .none
            return cell
        default:
            let cellid = self.cellid
            tableView.register(SelectQCell.self, forCellReuseIdentifier: cellid)
            let cell: SelectQCell = tableView.dequeueReusableCell(withIdentifier: cellid) as! SelectQCell
            cell.set(data[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
