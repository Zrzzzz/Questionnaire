//
//  MineViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class MyCreateViewController: UIViewController {
    // UI控件
    var searchController: UISearchController!
    var modeView: PaperModeSwitchView!
    var tableView: UITableView!
    // 变量
    let btnWidth = (screen.width - 20) / 3
    let cellId = "Questionnaire.MyCreateView.cell"
    var paperType = PaperType.quer {
        didSet {
            self.dataRefresh(type: self.paperType)
        }
    }
    // 数据
    var paperList: [MyCreatePaper] = [] // 这个用来存储刷新的数据
    
    var filterList: [MyCreatePaper] = [] {
        didSet {
            tableView.reloadData()
        }
    }// 这个用来做过滤等操作
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataRefresh(type: self.paperType)
    }
}



//MARK: - Delegate
extension MyCreateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCreateListCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MyCreateListCell
        cell.set(paper: filterList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let aPaper = self.filterList[indexPath.row]

        let alert = UIAlertController(title: "选择操作", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "编辑", style: .default) { _ in
            let paper = PaperManager.querPaper(by: aPaper)
            let vc = EditPaperViewController()
            vc.paper = paper
            self.navigationController?.pushViewController(vc, animated: true)
        }

        var action3 = UIAlertAction()
        let status = aPaper.status
        if status == .pubed {
            action3 = UIAlertAction(title: "停止", style: .destructive, handler: { (_) in
                // TODO: 停止问卷
            })
        } else if status == .notPub {
            action3 = UIAlertAction(title: "发布", style: .default, handler: { (_) in
                // 发布到云端
                let paper = PaperManager.querPaper(by: aPaper)
                NetManager.postPaper(by: paper) {
                    // 本地数据删除
                    PaperManager.deletePaper(by: paper)
                    PaperManager.deleteMyCreate(by: self.filterList[indexPath.row])
                    self.dataRefresh(type: self.paperType)
                }

            })
        }

        let action4 = UIAlertAction(title: "删除", style: .destructive) { _ in
            let alert = UIAlertController(title: "警告", message: nil, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let action2 = UIAlertAction(title: "删除", style: .destructive) { (_) in
                // TODO: Net删除Paper
                PaperManager.deleteMyCreate(by: self.filterList[indexPath.row])
                PaperManager.deletePapers(by: NSPredicate(format: "id == %d", self.filterList[indexPath.row].paperID))
                self.paperList.removeAll { (paper) -> Bool in
                    paper.paperID == aPaper.paperID
                }
                self.searchController.searchBar.text = self.searchController.searchBar.text
            }
            alert.addAction(action1)
            alert.addAction(action2)
            
            // 添加富文本
            let attrStr = NSMutableAttributedString(string: "是否删除" + self.filterList[indexPath.row].paperName, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
            
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: TColor.textRed, range: NSRange(location: 2, length: 2))
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: TColor.textBlue, range: NSRange(location: 4, length: self.filterList[indexPath.row].paperName.count))
            alert.setValue(attrStr, forKey: "attributedMessage")
            
            self.present(alert, animated: true)
        }
        
        alert.addAction(action1)
        if status == .notPub {
            alert.addAction(action2)
        }
        if status != .overed {
            alert.addAction(action3)
        }
        alert.addAction(action4)

        self.present(alert, animated: true)
        // 取消选定
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK: - UI
extension MyCreateViewController {
    private func setUp() {
        view.backgroundColor = .systemBackground
        
        // 搜索栏设置
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        // 让灰色蒙版消失: 此蒙版会阻挡我们点击
        searchController.obscuresBackgroundDuringPresentation = false

        // 外观设置
        title = "编辑问卷"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = .white
            textfield.placeholder = "搜索"
            textfield.attributedPlaceholder = NSAttributedString(string: "搜索", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange])
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = TColor.main
            }
        }
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        // 标题
        self.title = "我创建的"
        // 背景设置
        self.view.backgroundColor = TColor.bgGray
        
        // 切换模式的View
        modeView = PaperModeSwitchView(frame: CGRect(x: 0, y: 150, width: screen.width, height: 150))
        view.addSubview(modeView)
        modeView.querBtn.addTarget(self, action: #selector(changeList(btn:)), for: .touchUpInside)
        modeView.testBtn.addTarget(self, action: #selector(changeList(btn:)), for: .touchUpInside)
        modeView.voteBtn.addTarget(self, action: #selector(changeList(btn:)), for: .touchUpInside)
        
        tableView = UITableView(frame: CGRect(x: 0, y: btnWidth + 180, width: screen.width, height: screen.height - 150 - btnWidth - 30))
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        // 背景颜色
        tableView.backgroundColor = TColor.bgGray
        tableView.register(MyCreateListCell.self, forCellReuseIdentifier: "Questionnaire.MyCreateView.cell")
        tableView.register(MyJoinListCell.self, forCellReuseIdentifier: "Questionnaire.MyJoinView.cell")

        view.addSubview(tableView)
        
    }
}

//MARK: - 数据处理
extension MyCreateViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text! != "" else {
            filterList = paperList
            return
        }
        
        filterList = paperList.filter {
            $0.paperName.contains(searchController.searchBar.text!)
        }
    }
    
    fileprivate func dataRefresh(type: PaperType) {
        // 刷新数据, 先获取本地数据, 再请求网络, 如果不一样则刷新View并且保存
        self.paperList = PaperManager.getPaperInCreate(type: type)
        self.filterList = self.paperList
        
        NetManager.getCreatePaper(type: type) { (papers) in
            let set = Set<MyCreatePaper>(papers)
            let leftSet = set.subtracting(self.paperList)
            if leftSet.count != 0 {
                for paper in leftSet {
                    PaperManager.saveMyCreatePaper(by: paper)
                }
            }
            self.paperList = Array<MyCreatePaper>(set.union(self.paperList))
            // 进行排序, 两个条件
            self.paperList = self.paperList.sorted(by: {$0.paperName < $1.paperName}).sorted(by: {$0.status < $1.status})
            
            self.filterList = self.paperList
            
        }
    }
    
    @objc fileprivate func changeList(btn: UIButton) {
        switch btn.tag {
        case 0:
            self.paperType = .quer
        case 1:
            self.paperType = .test
        default:
            self.paperType = .vote
        }
    }
}


