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
    var querModeBtn: UIButton!
    var testModeBtn: UIButton!
    var voteModeBtn: UIButton!
    var tableView: UITableView!
    var scrollView: MyCreateScrollView?
    // 变量
    let btnWidth = (screen.width - 20) / 3
    let cellId = "Questionnaire.MyCreateView.cell"
    // 数据
    var paperList: [MyCreatePaper] = [] // 这个用来存储刷新的数据
    
    var filterList: [MyCreatePaper] = [] {
        didSet {
//            if let tableViews = scrollView?.tableViews {
//                tableViews.map {
//                    $0.reloadData()
//                }
//            }
            scrollView?.refresh(cellHeight: 180, dataCount: filterList.count)

        }
    }// 这个用来做过滤等操作
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // 刷新数据
        paperList = NetManager.getCreatePaper(type: .quer)
        filterList = paperList
        
        scrollView?.refresh(cellHeight: 180, dataCount: paperList.count)
    }
}



//MARK: - Delegate
extension MyCreateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case scrollView?.tableViews?.last:
            return filterList.count % scrollView!.cellCount == 0 ? scrollView!.cellCount : filterList.count % scrollView!.cellCount
        default:
            return scrollView!.cellCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pageIndex: Int = {
            let i = scrollView!.tableViews?.firstIndex { (tv) -> Bool in
                tv == tableView
            }
            return i ?? 0
        }()
        
        let cell: MyCreateListCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MyCreateListCell
        cell.set(paper: filterList[indexPath.row + scrollView!.cellCount * pageIndex])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "选择操作", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "编辑", style: .default) { _ in
            let paper = PaperManager.querPapers(by: NSPredicate(format: "paperName like %@", self.filterList[indexPath.row].paperName))[0]
            let vc = EditPaperViewController()
            vc.paper = paper
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let action3 = UIAlertAction(title: "删除", style: .destructive) { _ in
            // TODO: 删除Paper
            PaperManager.deletePapers(by: NSPredicate(format: "id like %@", self.filterList[indexPath.row].paperID))
            self.paperList.removeAll { (paper) -> Bool in
                paper.paperID == self.filterList[indexPath.row].paperID
            }
            self.searchController.searchBar.text = self.searchController.searchBar.text
            self.scrollView?.reloadInputViews()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
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
        
        voteModeBtn = createFilterBtn(title: "投票", tag: 2) { (btn) in
            self.view.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.width.height.equalTo(btnWidth)
                make.top.equalTo(view).offset(150)
                make.right.equalTo(view).offset(-5)
            }
            btn.setCornerRadius(radius: btnWidth / 2)
        }
        
        //        tableView = UITableView()
        //        tableView.dataSource = self
        //        tableView.delegate = self
        //        tableView.register(MyCreateListCell.self, forCellReuseIdentifier: cellId)
        //        view.addSubview(tableView)
        //        tableView.snp.makeConstraints { (make) in
        //            make.top.equalTo(querModeBtn.snp_bottom).offset(10)
        //            make.width.equalTo(screen.width)
        //            make.height.equalTo(screen.height - 150 - btnWidth - 10)
        //        }
        
        scrollView = MyCreateScrollView(frame: CGRect(x: 0, y: btnWidth + 160, width: screen.width, height: screen.height - 150 - btnWidth - 10), addPageControl: { (pageControl) in
            self.view.addSubview(pageControl)
        })
        scrollView?.tableViewDataSource = self
        scrollView?.tableViewDelegate = self
//        if let tableViews = scrollView?.tableViews {
//            tableViews.map {
//                $0.reloadData()
//            }
//        }
        self.view.addSubview(scrollView!)
        self.view.bringSubviewToFront(scrollView!.pageControl)
        
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
        print(searchController.searchBar.text!)
        guard searchController.searchBar.text! != "" else {
            filterList = paperList
            return
        }
        
        filterList = paperList.filter {
            $0.paperName.contains(searchController.searchBar.text!)
        }
        
    }
    
    
    
    @objc fileprivate func changeList(btn: UIButton) {
        switch btn.tag {
        case 0:
            paperList = NetManager.getCreatePaper(type: .quer)
        case 1:
            paperList = NetManager.getCreatePaper(type: .test)
        default:
            paperList = NetManager.getCreatePaper(type: .vote)
        }
        filterList = paperList
    }
}


