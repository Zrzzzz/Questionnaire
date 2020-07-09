//
//  MyCreateScrollView.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/5.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class MyCreateScrollView: UIScrollView, UIScrollViewDelegate {
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
    
    init(frame: CGRect, addPageControl: (UIPageControl) -> Void) {
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
            tableView.register(MyCreateListCell.self, forCellReuseIdentifier: "Questionnaire.MyCreateView.cell")
            
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
