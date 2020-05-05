//
//  MineViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {
    // UI控件
    var searchController: UISearchController!
    var querModeBtn: UIButton!
    var testModeBtn: UIButton!
    var voteModeBtn: UIButton!
    var tableView: UITableView!
    // 变量
    let btnWidth = (screen.width - 20) / 3
    let cellId = "Questionnaire.MineVC.cell"
    // 数据
    var itemList: [ItemModel] = [] {
        didSet {
            filterList = itemList
        }
    } // 这个用来存储刷新的数据
    var filterList: [ItemModel] = [] {
        didSet { tableView.reloadData() }
    }// 这个用来做过滤等操作
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // 刷新数据
        itemList = getData()

    }
}

//MARK: - Delegate
extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemListCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ItemListCell
        cell.set(item: filterList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//MARK: - UI
extension MineViewController {
    private func setUp() {
        view.backgroundColor = .systemBackground
        
        searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
        searchController.searchBar.placeholder = "搜索"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        querModeBtn = UIButton()
        querModeBtn.setTitle("问卷", for: .normal)
        querModeBtn.setTitleColor(TColor.text, for: .normal)
        querModeBtn.tag = 0
        querModeBtn.addTarget(self, action: #selector(changeList(btn:)), for: .touchUpInside)
        querModeBtn.backgroundColor = TColor.main
        view.addSubview(querModeBtn)
        querModeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(btnWidth)
            make.top.equalTo(view).offset(150)
            make.left.equalTo(view).offset(5)
        }
        querModeBtn.setCornerRadius(radius: btnWidth / 2)
        
        testModeBtn = UIButton()
        testModeBtn.setTitle("答题", for: .normal)
        testModeBtn.setTitleColor(TColor.text, for: .normal)
        testModeBtn.tag = 1
        testModeBtn.addTarget(self, action: #selector(changeList(btn:)), for: .touchUpInside)
        testModeBtn.backgroundColor = TColor.main
        view.addSubview(testModeBtn)
        testModeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(btnWidth)
            make.top.equalTo(view).offset(150)
            make.centerX.equalTo(view)
        }
        testModeBtn.setCornerRadius(radius: btnWidth / 2)
        
        voteModeBtn = UIButton()
        voteModeBtn.setTitle("投票", for: .normal)
        voteModeBtn.setTitleColor(TColor.text, for: .normal)
        voteModeBtn.tag = 2
        voteModeBtn.addTarget(self, action: #selector(changeList(btn:)), for: .touchUpInside)
        voteModeBtn.backgroundColor = TColor.main
        view.addSubview(voteModeBtn)
        voteModeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(btnWidth)
            make.top.equalTo(view).offset(150)
            make.right.equalTo(view).offset(-5)
        }
        voteModeBtn.setCornerRadius(radius: btnWidth / 2)
        
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ItemListCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(querModeBtn.snp_bottom).offset(10)
            make.width.equalTo(screen.width)
            make.height.equalTo(screen.height - 150 - btnWidth - 10)
        }
    }
}

//MARK: - 数据处理
extension MineViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != "" && itemList.contains(where: { (item) -> Bool in
            (item.title ?? "").contains(searchController.searchBar.text!)
        }) else { return }
        filterList = itemList.filter {
            ($0.title ?? "").contains(searchController.searchBar.text!)
        }

    }
    
    private func getData() -> [ItemModel] {
        return [
            ItemModel(id: nil, title: "问卷1", explain: nil, type: .quer, status: .pubed, count: 1895),
            ItemModel(id: nil, title: "问卷2", explain: nil, type: .quer, status: .overed, count: 1895),
            ItemModel(id: nil, title: "问卷3", explain: nil, type: .quer, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "问卷4", explain: nil, type: .quer, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "问卷5", explain: nil, type: .quer, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "投票1", explain: nil, type: .vote, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "投票2", explain: nil, type: .vote, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "投票3", explain: nil, type: .vote, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "投票4", explain: nil, type: .vote, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "投票5", explain: nil, type: .vote, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "答题1", explain: nil, type: .test, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "答题2", explain: nil, type: .test, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "答题3", explain: nil, type: .test, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "答题4", explain: nil, type: .test, status: .notPub, count: 1895),
            ItemModel(id: nil, title: "答题5", explain: nil, type: .test, status: .notPub, count: 1895)
        ]
    }
    
    @objc private func changeList(btn: UIButton) {
           let str: String
           switch btn.tag {
           case 0:
               str = ItemType.quer.rawValue
           case 1:
               str = ItemType.test.rawValue
           default:
               str = ItemType.vote.rawValue
           }
        filterList = itemList.filter{
            ($0.title ?? "").contains(str)
        }
        tableView.reloadData()
       }
}


