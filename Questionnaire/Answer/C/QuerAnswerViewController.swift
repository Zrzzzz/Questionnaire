//
//  QuerAnswerViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/20.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class QuerAnswerViewController: UIViewController {
    /* UI */
    var submitBtn: UIButton!
    var collectionView: UICollectionView!
    var ansCardView: AnsCardCollectionView!
    
    /* variable */
    let singleid = "Questionnaire.QuerAnsVC.single.cell"
    let multipleid = "Questionnaire.QuerAnsVC.multiple.cell"
    let blankid = "Questionnaire.QuerAnsVC.blank.cell"
    
    /* data */
    // 卷子
    var paper: Paper? {
        didSet {
            quesData = paper?.paperQuestion
        }
    }
    // 题目数据
    var quesData: PaperQuestion? {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
            
            quesCount = {
                var count = 0
                count += quesData!.blank.count
                count += quesData!.single.count
                count += quesData!.multiple.count
                return count
            }()
        }
    }
    // TODO: 存储答案
    var quesAnswer: Any!
    
    // 题目数量
    var quesCount: Int = 0
    var answeredQues: [Int] = [] {
        didSet {
            navigationItem.rightBarButtonItem?.title = "已作答\(answeredQues.count)/\(quesCount)题"
        }
    }
    
    // 显示答题卡
    var isShowingCard = false {
        didSet {
            if isShowingCard {
                view.addSubview(ansCardView)
            } else {
                ansCardView.removeFromSuperview()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if paper != nil {
            setup()
        }
    }
    
}

//MARK: - UI
extension QuerAnswerViewController {
    private func setup() {
        // collectionView
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: screen.width * 0.8, height: 60)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        
        // navigationBar
        title = paper?.paperName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "已作答\(answeredQues.count)/\(quesCount)题", style: .plain, target: self, action: #selector(toggleCardView))
        
        // 答题卡
        ansCardView = AnsCardCollectionView(frame: CGRect(x: 0, y: 40, width: screen.width, height: 100), totalCount: 10)
        
        // collectionView
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height / 13 * 12), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = TColor.bgGray
        collectionView.register(AnsSingleCollectionViewCell.self, forCellWithReuseIdentifier: self.singleid)
        collectionView.register(AnsMultipleCollectionViewCell.self, forCellWithReuseIdentifier: self.multipleid)
        collectionView.register(AnsBlankCollectionViewCell.self, forCellWithReuseIdentifier: self.blankid)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.scrollsToTop = true
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        // 底部按钮
        submitBtn = UIButton(frame: CGRect(x: 0, y: screen.height / 13 * 12, width: screen.width, height: screen.height / 13))
        view.addSubview(submitBtn)
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.backgroundColor = TColor.main
        submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }
    
    @objc private func toggleCardView() {
        self.isShowingCard.toggle()
    }
    
    @objc private func submit() {
        // TODO: 提取答案, 本地存储, 网络请求
        print("提交成功")
//        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Delegate
extension QuerAnswerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let question = self.quesData {
            count += question.blank.count
            count += question.single.count
            count += question.multiple.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var ques: Any
        switch self.calcIndex(row: indexPath.row) {
        case (.single, let index):
            ques = self.quesData!.single[index]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: singleid, for: indexPath) as! AnsSingleCollectionViewCell
            cell.update(by: ques as! Single, row: indexPath.row + 1) // +1是题号
         
            // FIXME: 有些问题
            cell.newTapGesture { (tap) in
                tap.numberOfTapsRequired = 1
            }.whenTaped { (_) in
                if !self.answeredQues.contains(indexPath.row + 1) {
                    self.answeredQues.append(indexPath.row + 1)
                }
            }
            return cell
            
        case (.multiple, let index):
            ques = self.quesData!.multiple[index]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: multipleid, for: indexPath) as! AnsMultipleCollectionViewCell
            cell.update(by: ques as! Multiple, row: indexPath.row + 1) // +1是题号
            
            // FIXME: 有些问题
            cell.newTapGesture { (tap) in
                tap.numberOfTapsRequired = 1
            }.whenTaped { (_) in
                if !self.answeredQues.contains(indexPath.row + 1) {
                    self.answeredQues.append(indexPath.row + 1)
                }
            }
            return cell
            
        case (.blank, let index):
            ques = self.quesData!.blank[index]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: blankid, for: indexPath) as! AnsBlankCollectionViewCell
            cell.update(by: ques as! Blank, row: indexPath.row + 1)
            
            // FIXME: 有些问题
            cell.newTapGesture { (tap) in
                tap.numberOfTapsRequired = 1
            }.whenTaped { (_) in
                if !self.answeredQues.contains(indexPath.row + 1) {
                    self.answeredQues.append(indexPath.row + 1)
                }
            }
            return cell
            
        case (.rating, _):
            // TODO: rating
            ques = Single() 
        }
        return UICollectionViewCell()
    }
    
    
    private func calcIndex(row: Int) -> (QuesType, Int) {
        if let singleCount = self.quesData?.single.count,
            let multiCount = self.quesData?.multiple.count,
            let blankCount = self.quesData?.blank.count {
            switch row {
            case 0..<singleCount:
                return (.single, row)
            case singleCount..<singleCount + multiCount:
                return (.multiple, row - singleCount)
            case singleCount + multiCount..<singleCount + multiCount + blankCount:
                return (.blank, row - (singleCount + multiCount))
            default: break
            }
        }
        return (.single, 0)
    }

}
