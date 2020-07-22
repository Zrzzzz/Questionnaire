//
//  MyJoinViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/10.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class MyJoinViewController: UIViewController {
    // UI控件
    var searchController: UISearchController!
    var modeView: PaperModeSwitchView!
    var tableView: UITableView!
    // 变量
    let btnWidth = (screen.width - 20) / 3
    let cellId = "Questionnaire.MyJoinView.cell"
    // 数据
    var paperList: [MyJoinPaper] = [] // 这个用来存储刷新的数据
    
    var filterList: [MyJoinPaper] = [] {
        didSet {
            tableView.reloadData()
        }
    }// 这个用来做过滤等操作
    
    var paperType = PaperType.quer {
        didSet {
            self.dataRefresh(type: self.paperType)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // 刷新数据
        paperList = NetManager.getJoinPaper(type: .quer)
        filterList = paperList
        
        dataRefresh(type: self.paperType)
    }
}



//MARK: - Delegate
extension MyJoinViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyJoinListCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MyJoinListCell
        cell.set(paper: filterList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "选择操作", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "作答", style: .default) { _ in
            // TODO: 改为从网络请求Paper
            let paper = PaperManager.querPaper(by: self.filterList[indexPath.row])
            let vc = QuerAnswerViewController()
            vc.paper = paper
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true)
        // 取消选定
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - UI
extension MyJoinViewController {
    private func setUp() {
        view.backgroundColor = .systemBackground
        
        // 搜索栏设置
        searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        // 外观设置
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
        self.title = "我参与的"
        // 背景颜色
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
extension MyJoinViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
        guard searchController.searchBar.text! != "" else {
            filterList = paperList
            return
        }
        
        filterList = paperList.filter {
            $0.paperName.contains(searchController.searchBar.text!)
        }
        
    }
    
    fileprivate func dataRefresh(type: PaperType) {
        
        self.paperList = NetManager.getJoinPaper(type: .quer)
        self.filterList = paperList
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
