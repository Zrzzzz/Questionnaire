//
//  MineViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

let jsonData = "{\"user_id\": 1234,     \"paper_name\": \"ZZZ\",     \"paper_comment\": \"dw\",     \"start_time\": 1234,     \"end_time\": 1234,     \"paper_type\": \"\",     \"paper_question\": {         \"single\": [{             \"question\": \"wdwd\",             \"options\": [                 \"hhaha\", \"hahhaha\"             ],             \"right_answer\": 3,             \"random\": 0,             \"necessary\": 0         }],         \"multiple\": [{             \"question\": \"wdawda\",             \"options\": [                 \"hhaha\", \"hahhaha\"             ],             \"right_answer\": [1, 2],             \"random\": 0,             \"necessary\": 0         }],         \"blank\": [{             \"id\": \"dwad\",             \"question\": \"wjdawd\",             \"right_answer\": \"wdawd\",             \"necessary\": 0         }]     },     \"random\": 123,     \"times\": 123 }"

class MyCreateViewController: UIViewController {
    // UI控件
    var searchController: UISearchController!
    var querModeBtn: UIButton!
    var testModeBtn: UIButton!
    var voteModeBtn: UIButton!
    var tableView: UITableView!
    // 变量
    let btnWidth = (screen.width - 20) / 3
    let cellId = "Questionnaire.MyCreateView.cell"
    // 数据
    var paperList: [MyCreatePaper] = [] // 这个用来存储刷新的数据
    
    var filterList: [MyCreatePaper] = [] {
        didSet { tableView.reloadData() }
    }// 这个用来做过滤等操作
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // 刷新数据
        paperList = getData()
        filterList = paperList
    }
}



//MARK: - Delegate
extension MyCreateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCreateListCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MyCreateListCell
        cell.set(paper: filterList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "选择操作", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "编辑", style: .default) { _ in
            
            
        }
        
        let action3 = UIAlertAction(title: "删除", style: .destructive) { _ in
            // TODO: 删除Paper
            self.paperList.removeAll { (paper) -> Bool in
                paper.paperID == self.filterList[indexPath.row].paperID
            }
            self.searchController.searchBar.text = self.searchController.searchBar.text
            tableView.reloadData()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        self.present(alert, animated: true)
    }
    
}

//MARK: - UI
extension MyCreateViewController {
    private func setUp() {
        view.backgroundColor = .systemBackground
        
        // 搜索栏设置
        searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "搜索个屁", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = TColor.main
            }
        }
        
        
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        // 标题
        self.title = "我创建的"
        
       
        querModeBtn = createFilterBtn(title: "问卷", tag: 0) { (btn) in
            self.view.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.width.height.equalTo(btnWidth)
                make.top.equalTo(view).offset(150)
                make.left.equalTo(view).offset(5)
            }
            btn.setCornerRadius(radius: btnWidth / 2)
        }
        
        testModeBtn = createFilterBtn(title: "答题", tag: 1) { (btn) in
            self.view.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.width.height.equalTo(btnWidth)
                make.top.equalTo(view).offset(150)
                make.centerX.equalTo(view)
            }
            btn.setCornerRadius(radius: btnWidth / 2)
        }
        
        voteModeBtn = createFilterBtn(title: "问卷", tag: 0) { (btn) in
            self.view.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.width.height.equalTo(btnWidth)
                make.top.equalTo(view).offset(150)
                make.right.equalTo(view).offset(-5)
            }
            btn.setCornerRadius(radius: btnWidth / 2)
        }
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyCreateListCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(querModeBtn.snp_bottom).offset(10)
            make.width.equalTo(screen.width)
            make.height.equalTo(screen.height - 150 - btnWidth - 10)
        }
    }
    
    private func createFilterBtn(title: String, tag: Int, snpSet: (UIButton) -> Void) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(TColor.text, for: .normal)
        btn.tag = tag
        btn.addTarget(self, action: #selector(changeList(btn:)), for: .touchUpInside)
        btn.backgroundColor = TColor.main
        
        snpSet(btn)
        
        return btn
    }
}

//MARK: - 数据处理
extension MyCreateViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != "" && paperList.contains(where: { (item) -> Bool in
            item.paperName.contains(searchController.searchBar.text!)
        }) else {
            filterList = paperList
            return
        }
        
        filterList = paperList.filter {
            $0.paperName.contains(searchController.searchBar.text!)
        }
        
    }
    
    private func getData() -> [MyCreatePaper] {
        var papers = [MyCreatePaper]()
        for i in 1...3 {
            papers.append(MyCreatePaper(paperID: UUID().uuidString, paperName: "问卷\(i)", star: 1, number: 999, status: .notPub, paperType: .quer))
        }
        for i in 1...3 {
            papers.append(MyCreatePaper(paperID: UUID().uuidString, paperName: "投票\(i)", star: 1, number: 999, status: .notPub, paperType: .vote))
        }
        for i in 1...3 {
            papers.append(MyCreatePaper(paperID: UUID().uuidString, paperName: "答题\(i)", star: 1, number: 999, status: .notPub, paperType: .test))
        }

        return papers
        
    }
    
    @objc private func changeList(btn: UIButton) {
        let s: PaperType
        switch btn.tag {
        case 0:
            s = PaperType.quer
        case 1:
            s = PaperType.test
        default:
            s = PaperType.vote
        }
        filterList = paperList.filter{
            $0.paperType == s
        }
        
    }
}


