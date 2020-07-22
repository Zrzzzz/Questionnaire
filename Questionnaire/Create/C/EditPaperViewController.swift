//
//  EditPaperViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/31.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class EditPaperViewController: UIViewController, EditPaperDelegate {
    
    /* UI */
    var finishBtn: UIButton!
    var collectionView: UICollectionView!
    var addBtn: UIButton!
    
    /* variable */
    let quesCellId = "Questionnaire.EditPaperVC.qeusCell"
    let paperCellId = "Questionnaire.EditPaperVC.paperCell"
    
    // Paper
    var paper: Paper? {
        didSet {
            quesData = paper?.paperQuestion
        }
    }
    // 问题
    var quesData: PaperQuestion? {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if paper != nil {
            setup()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quesData = paper?.paperQuestion
    }
}

//MARK: - UI
extension EditPaperViewController {
    private func setup() {
        
        // 右边按钮
        title = "编辑问卷"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: .plain, target: self, action: #selector(setVC))
        
        // 底部按钮
        finishBtn = UIButton(frame: CGRect(x: 0, y: screen.height / 13 * 12, width: screen.width, height: screen.height / 13))
        view.addSubview(finishBtn)
        finishBtn.setTitle("保存", for: .normal)
        finishBtn.backgroundColor = TColor.main
        finishBtn.addTarget(self, action: #selector(savePaper), for: .touchUpInside)
        
        // collectionView
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: screen.width * 0.8, height: 60)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height / 13 * 12), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = TColor.bgGray
        collectionView.register(EditQuesCollectionViewCell.self, forCellWithReuseIdentifier: quesCellId)
        collectionView.register(EditPaperCollectionViewCell.self, forCellWithReuseIdentifier: paperCellId)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.scrollsToTop = true
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        // addBtn
        addBtn = UIButton(frame: CGRect(x: screen.width / 5 * 4, y: screen.height / 6.5 * 5.5, width: 60, height: 60))
        addBtn.setImage(UIImage(named: "editpapervc_plus"), for: .normal)
        addBtn.setCornerRadius(radius: 30)
        addBtn.addTarget(self, action: #selector(addQues), for: .touchUpInside)
        view.addSubview(addBtn)
    }
    
    @objc fileprivate func savePaper() {
        PaperManager.update(by: paper!)
        // 总数-2, 即获取前一个VC(self.parent不太管用)
        if let vc = navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2] {
            if type(of: vc) == MyCreateViewController.self {
                navigationController?.popViewController(animated: true)
            } else {
                // 分情况, 这种就是从首页进去的, 直接回到首页
                navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    @objc fileprivate func setVC() {
        navigationController?.pushViewController(SettingQuerViewController(), animated: true)
    }
    
    @objc fileprivate func addQues() {
        let createVC = CreateCenterViewController()
        createVC.delegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }
        
}

//MARK: - CollectionView
extension EditPaperViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let question = self.quesData {
            count += question.blank.count
            count += question.single.count
            count += question.multiple.count
        }
        return count + 1 // 还有个标题
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: paperCellId, for: indexPath) as! EditPaperCollectionViewCell
            cell.titleLabel.text = paper?.paperName
            if paper?.paperComment != "" {
                cell.commentLabel?.text = paper?.paperComment!
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: quesCellId, for: indexPath) as! EditQuesCollectionViewCell
            var ques: Any
            switch self.calcIndex(row: indexPath.row) {
            case (.single, let index):
                ques = self.quesData!.single[index]
            case (.multiple, let index):
                ques = self.quesData!.multiple[index]
            case (.blank, let index):
                ques = self.quesData!.blank[index]
            case (.rating, _):
                // TODO: rating
                ques = Single()
            }
            cell.update(by: ques, row: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row != 0 {
            let alert = UIAlertController(title: "题目编辑", message: nil, preferredStyle: .alert)
            let cancelAct = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let editAct = UIAlertAction(title: "编辑", style: .default) { (_) in
                
                var ques: Any
                switch self.calcIndex(row: indexPath.row) {
                case (.single, let index):
                    ques = self.quesData!.single[index]
                    let vc = SingleAddViewController(by: ques as! Single)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case (.multiple, let index):
                    ques = self.quesData!.multiple[index]
                    let vc = MultipleAddViewController(by: ques as! Multiple)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                case (.blank, let index):
                    ques = self.quesData!.blank[index]
                    let vc = BlankAddViewController(by: ques as! Blank)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                
                case (.rating, _):
                    // TODO: rating
                    return
                }
            }
            let upAct = UIAlertAction(title: "上移", style: .default) { (_) in
                switch self.calcIndex(row: indexPath.row) {
                case (.single, let index):
                    if index != 0 {
                        self.quesData!.single.swapAt(index - 1, index)
                    }
                case (.multiple, let index):
                    if index != 0 {
                        self.quesData!.multiple.swapAt(index - 1, index)
                    }
                case (.blank, let index):
                    if index != 0 {
                        self.quesData!.blank.swapAt(index - 1, index)
                    }
                case (.rating, _):
                    // TODO: rating
                    return
                }
                collectionView.reloadSections(IndexSet(arrayLiteral: indexPath.section))
            }
            let downAct = UIAlertAction(title: "下移", style: .default) { (_) in
                switch self.calcIndex(row: indexPath.row) {
                case (.single, let index):
                    if index != self.quesData!.single.count - 1 {
                        self.quesData!.single.swapAt(index + 1, index)
                    }
                case (.multiple, let index):
                    if index != self.quesData!.multiple.count - 1 {
                        self.quesData!.multiple.swapAt(index + 1, index)
                    }
                case (.blank, let index):
                    if index != self.quesData!.blank.count - 1 {
                        self.quesData!.blank.swapAt(index + 1, index)
                    }
                    // TODO: Rating
                case (.rating, let index):
                    return
                }

                collectionView.reloadSections(IndexSet(arrayLiteral: indexPath.section))
            }
            let delAct = UIAlertAction(title: "删除", style: .destructive) { (_) in
                switch self.calcIndex(row: indexPath.row) {
                case (.single, let index):
                    self.quesData?.single.remove(at: index)
                case (.multiple, let index):
                    self.quesData?.multiple.remove(at: index)
                case (.blank, let index):
                    self.quesData?.blank.remove(at: index)
                    // TODO: Rating
                case (.rating, let index):
                    return
                }
                
                collectionView.reloadSections(IndexSet(arrayLiteral: indexPath.section))
            }
            
            alert.addAction(cancelAct)
            alert.addAction(editAct)
            alert.addAction(upAct)
            alert.addAction(downAct)
            alert.addAction(delAct)
            
            self.present(alert, animated: true)
        }
    }
    
    private func calcIndex(row: Int) -> (QuesType, Int) {
        if let singleCount = self.quesData?.single.count,
            let multiCount = self.quesData?.multiple.count,
            let blankCount = self.quesData?.blank.count {
            switch row - 1 {
            case 0..<singleCount:
                return (.single, row - 1)
            case singleCount..<singleCount + multiCount:
                return (.multiple, row - 1 - singleCount)
            case singleCount + multiCount..<singleCount + multiCount + blankCount:
                return (.blank, row - 1 - (singleCount + multiCount))
            default: break
            }
        }
        return (.single, 0)
    }
}

