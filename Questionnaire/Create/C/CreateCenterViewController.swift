//
//  CreateCenterViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/31.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class CreateCenterViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var types: [String] = ["单选题", "多选题", "填空题", "段落题", "排序题"]
    
    let cellId = "Questionnaire.CreateCenterCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = TColor.bgWhite
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back))
        title = "添加题目"
        
        setUp()
    }
    
    @objc private func back() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}

//MARK: - UI
extension CreateCenterViewController {
    private func setUp() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: screen.width - 100, height: 80)
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30)
        collectionView = UICollectionView(frame: screen, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = TColor.bgGray
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
    
    
}
