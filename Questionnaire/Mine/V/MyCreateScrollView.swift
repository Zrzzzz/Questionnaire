//
//  MyPaperScrollView.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/5.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

/// 由于产品改来改去,这个ScrollView又不需要了, 使用方法放到最下面
class MyPaperScrollView: UIScrollView, UIScrollViewDelegate {
    /* UI */
    var tableViews: [UITableView?]? = []
    var pageControl = UIPageControl()
    
    /* 代理 */
    var tableViewDelegate: UITableViewDelegate?
    var tableViewDataSource: UITableViewDataSource?
    /* 常量 */
    // 一页有多少个cell
    var cellCount: Int = 0
    // tableView高度
    var tableViewHeight: CGFloat = 0
    // 页数
    var pageCount: Int = 0
    // join or create
    var type = MyType.join
    init(frame: CGRect, type: MyType, addPageControl: (UIPageControl) -> Void) {
        super.init(frame: frame)
        
        //MARK: - SetupSelf
        
        // 允许分页
        isPagingEnabled = true
        // 滚动条
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        // 自动爬顶
        scrollsToTop = false
        // 弹性
        bounces = true
        // 偏移
        contentOffset = CGPoint.zero
        // 代理
        delegate = self
        // myType
        self.type = type
        
        //MARK: - SetupPageControl
        
        // 添加PageControl视图
        pageControl.currentPageIndicatorTintColor = TColor.main
        addPageControl(pageControl) // 需要在外部引用
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func calcPageControlFrame(frame: CGRect, tableViewHeight: CGFloat) -> CGRect {
        let width = frame.width * 0.3 // 宽度
        let startY = tableViewHeight + frame.minY
        let startX = frame.midX - width / 2
        let height:CGFloat = frame.height * 0.1 < 50 ? frame.height : 50
        
        return CGRect(x: startX, y: startY, width: width, height: height)
    }
    
    func refresh(cellHeight: CGFloat, dataCount: Int) {
        // 预设高度
        cellCount = Int(floor((frame.height * 0.9) / cellHeight)) // 留点地方放pageControl
        pageCount = Int(ceil(Double(dataCount) / Double(cellCount)))
        tableViewHeight = CGFloat(cellCount) * cellHeight
        // 设置内容尺寸, 实际上分页只是将一张纸切成了几块
        contentSize = CGSize(width: frame.width * CGFloat(pageCount), height: frame.height)
        // pageControl
        pageControl.numberOfPages = pageCount
        
        //MARK: - SetupTableView
        
        //        guard Mirror(reflecting: datas).subjectType == [MyCreatePaper].self else { fatalError("Datas type fault!") }
        //        papers = datas as! [MyCreatePaper]
        if !(tableViews?.isEmpty ?? true) {
            for tv in tableViews! {
                tv?.removeFromSuperview()
            }
            tableViews?.removeAll()
        }
        for page in 0..<pageCount {
            let tableView = UITableView(frame: CGRect(x: CGFloat(page) * frame.width, y: 0, width: frame.width, height: tableViewHeight))
            // 设置代理
            tableView.delegate = self.tableViewDelegate
            tableView.dataSource = self.tableViewDataSource
            // 滚动
            tableView.isScrollEnabled = false
            tableView.separatorStyle = .none
            // 背景颜色
            tableView.backgroundColor = TColor.bgGray
            if type == .create {
                tableView.register(MyCreateListCell.self, forCellReuseIdentifier: "Questionnaire.MyCreateView.cell")
            } else {
                tableView.register(MyJoinListCell.self, forCellReuseIdentifier: "Questionnaire.MyJoinView.cell")
            }
            
            tableViews?.append(tableView)
            self.addSubview(tableView)
        }
        // 设定尺寸
        pageControl.frame = self.calcPageControlFrame(frame: frame, tableViewHeight: tableViewHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        pageControl.currentPage = Int(offset.x / frame.width)
    }
}


// 刷新数据
//scrollView?.refresh(cellHeight: 180, dataCount: filterList.count)

// 代理设置, 主要难点在于计算pageIndex
//MARK: - Delegate
//extension MyCreateViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch tableView {
//        case scrollView?.tableViews?.last:
//            return filterList.count % scrollView!.cellCount == 0 ? scrollView!.cellCount : filterList.count % scrollView!.cellCount
//        default:
//            return scrollView!.cellCount
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let pageIndex: Int = {
//            let i = scrollView!.tableViews?.firstIndex { (tv) -> Bool in
//                tv == tableView
//            }
//            return i ?? 0
//        }()
//
//        let cell: MyCreateListCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MyCreateListCell
//        cell.set(paper: filterList[indexPath.row + scrollView!.cellCount * pageIndex])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 180
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let pageIndex: Int = {
//            let i = scrollView!.tableViews?.firstIndex { (tv) -> Bool in
//                tv == tableView
//            }
//            return i ?? 0
//        }()
//        let aPaper = self.filterList[indexPath.row + scrollView!.cellCount * pageIndex]
//
//        let alert = UIAlertController(title: "选择操作", message: nil, preferredStyle: .alert)
//        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        let action2 = UIAlertAction(title: "编辑", style: .default) { _ in
//            let paper = PaperManager.querPaper(by: aPaper)
//            let vc = EditPaperViewController()
//            vc.paper = paper
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//        var action3 = UIAlertAction()
//        let status = aPaper.status
//        if status == .pubed {
//            action3 = UIAlertAction(title: "停止", style: .destructive, handler: { (_) in
//                // TODO: 停止问卷
//            })
//        } else if status == .notPub {
//            action3 = UIAlertAction(title: "发布", style: .default, handler: { (_) in
//                // 发布到云端
//                let paper = PaperManager.querPaper(by: aPaper)
//                NetManager.postPaper(by: paper) {
//                    // 本地数据删除
//                    PaperManager.deletePaper(by: paper)
//                }
//
//            })
//        }
//
//        let action4 = UIAlertAction(title: "删除", style: .destructive) { _ in
//            // TODO: 删除Paper
//            PaperManager.deletePapers(by: NSPredicate(format: "id == %d", self.filterList[indexPath.row].paperID))
//            self.paperList.removeAll { (paper) -> Bool in
//                paper.paperID == aPaper.paperID
//            }
//            self.searchController.searchBar.text = self.searchController.searchBar.text
//            self.scrollView?.reloadInputViews()
//        }
//        alert.addAction(action1)
//        if status == .notPub {
//            alert.addAction(action2)
//        }
//        if status != .overed {
//            alert.addAction(action3)
//        }
//        alert.addAction(action4)
//
//        self.present(alert, animated: true)
//        // 取消选定
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//}
//
