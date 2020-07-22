//
//  AnsCardView.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/22.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class AnsCardCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    var totalCount: Int = 0
    
    
    convenience init(frame: CGRect, totalCount: Int) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        
        self.init(frame: frame, collectionViewLayout: layout)
        self.totalCount = totalCount
        
        self.register(AnsCardCollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        self.delegate = self
        self.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! AnsCardCollectionViewCell
        cell.label.text = (indexPath.row + 1).description
        return cell
    }
}

class AnsCardCollectionViewCell: UICollectionViewCell {
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        
        label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.center.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
