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
    
    /* data */
    let quesCellId = "Questionnaire.EditPaperVC.qeusCell"
    let paperCellId = "Questionnaire.EditPaperVC.paperCell"
    
    /* Ques */
//    lazy var array: [Single] = {
//        var arr = Array<Single>()
//        for i in 1..<20 {
//            arr.append(Single(id: UUID().uuidString, question: "题目\(i)", options: ["A","B","C"], rightAnswer: 0, random: 0, necessary: 0, score: 4))
//        }
//        return arr
//    }()
    
    
//    lazy var array: [Blank] = {
//        var arr = Array<Blank>()
//        for i in 1..<20 {
//            arr.append(Blank(id: UUID().uuidString, question: "问题\(i)", rightAnswer: nil, necessary: 0, score: 0))
//        }
//        return arr
//    }()
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
        addBtn.setImage(UIImage(named: "editpaper_plus"), for: .normal)
        addBtn.setCornerRadius(radius: 30)
        addBtn.addTarget(self, action: #selector(addQues), for: .touchUpInside)
        view.addSubview(addBtn)
    }
    
    @objc fileprivate func savePaper() {
        PaperManager.update(by: paper!)
        navigationController?.popToRootViewController(animated: true)
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
            if paper?.paperComment != nil {
                cell.commentLabel?.text = paper?.paperComment!
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: quesCellId, for: indexPath) as! EditQuesCollectionViewCell
            var ques: Any
            if let singleCount = self.quesData?.single.count,
                let multiCount = self.quesData?.multiple.count,
            let blankCount = self.quesData?.blank.count {
                switch indexPath.row - 1 {
                case 0..<singleCount:
                    ques = quesData!.single[indexPath.row - 1]
                case singleCount..<singleCount + multiCount:
                    ques = quesData!.multiple[indexPath.row - 1 - singleCount]
                case singleCount + multiCount..<singleCount + multiCount + blankCount:
                    ques = quesData!.blank[indexPath.row - 1 - (singleCount + multiCount)]
                default:
                    ques = Single()
                }
                cell.update(by: ques)
            }
            return cell
        }
    }
}

