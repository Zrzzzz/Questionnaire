//
//  CreateCenterViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/31.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class CreateCenterViewController: UIViewController {
    var delegate: EditPaperDelegate?
    
    var collectionView: UICollectionView!
    var types: [String] = ["单选题", "多选题", "填空题", "量表题", "排序题"]
    
    let cellId = "Questionnaire.CreateCenterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
}

//MARK: - UI
extension CreateCenterViewController {
    private func setUp() {
        // view
        view.backgroundColor = TColor.bgWhite
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        title = "添加题目"
        
        // collectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: screen.width - 100, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30)
        collectionView = UICollectionView(frame: screen, collectionViewLayout: layout)
        collectionView.backgroundColor = TColor.bgGray
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QuestionCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
}

//MARK: - Delegate
extension CreateCenterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! QuestionCollectionViewCell
        cell.update(text: types[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let single = SingleAddViewController()
            single.delegate = self.delegate
            navigationController?.pushViewController(single, animated: true)
        case 1:
            let multi = MultipleAddViewController()
            multi.delegate = self.delegate
            navigationController?.pushViewController(multi, animated: true)
        case 2:
            let blank = BlankAddViewController()
            blank.delegate = self.delegate
            navigationController?.pushViewController(blank, animated: true)
        case 3:
            let rating = RatingAddViewController()
            rating.delegate = self.delegate
            navigationController?.pushViewController(rating, animated: true)
        default:
            return
        }
    }
    
    
}
