//
//  HomeViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // 控件
    var searchController: UISearchController!
    var collectionView: UICollectionView!
    // 变量
    let cellId = "Questionnaire.HomeVC.Cell"
    let parts = ["新建", "我创建的", "我参与的", "查看标星", "回收站"]
    let partsImgs: [String] = ["create", "mycreate", "myjoin", "star", "trash"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
}

//MARK: - UI
extension HomeViewController: UISearchControllerDelegate {
    
    private func setUp() {
        view.backgroundColor = TColor.bar
        setStatusBar()
        drawSearchController()
        drawNavigationBar()
        drawCollectionView()
    }
    
    private func drawSearchController() {
        let resultsTableViewController = SearchResultsTableViewController()
        
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = resultsTableViewController
//        definesPresentationContext = true
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        searchController.searchBar.delegate = resultsTableViewController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.sizeToFit()
        
        navigationItem.searchController = self.searchController
    }
    
    private func setStatusBar() {
        if #available(iOS 13.0, *) {


           let statusBar1 =  UIView()
            statusBar1.frame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager!.statusBarFrame as! CGRect
            statusBar1.backgroundColor = TColor.main

           UIApplication.shared.keyWindow?.addSubview(statusBar1)

        } else {

           let statusBar1: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
           statusBar1.backgroundColor = UIColor.black
        }
    }
    
    private func drawNavigationBar() {
        navigationItem.title = "问卷答题投票"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(sideListOnTouch))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.barTintColor = TColor.bar
        navigationController?.navigationBar.backgroundColor = TColor.bar
        navigationController?.navigationBar.tintColor = TColor.text
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: TColor.text]
    }
    
    private func drawCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: screen.width - 100, height: 80)
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30)
        collectionView = UICollectionView(frame: screen, collectionViewLayout: layout)
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = TColor.bgGray
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

//MARK: - Select Method
extension HomeViewController {
    @objc func sideListOnTouch() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}

//MARK: - Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        parts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: cellId)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeViewCell
        cell.update(img: UIImage(named: partsImgs[indexPath.row])!, with: parts[indexPath.row], needArrow: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let alert = UIAlertController(title: "选择模式", message: nil, preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let action2 = UIAlertAction(title: "问卷", style: .default) { (_) in
                let createVC = CreatePaperViewController()
                createVC.type = .quer
                self.navigationController?.pushViewController(createVC, animated: true)
            }
            let action3 = UIAlertAction(title: "投票", style: .default) { (_) in
                let createVC = CreatePaperViewController()
                createVC.type = .vote
                self.navigationController?.pushViewController(createVC, animated: true)
            }
            let action4 = UIAlertAction(title: "答题", style: .default) { (_) in
                let createVC = CreatePaperViewController()
                createVC.type = .test
                self.navigationController?.pushViewController(createVC, animated: true)
            }
            alert.addAction(action1)
            alert.addAction(action2)
            alert.addAction(action3)
            alert.addAction(action4)
            
            self.present(alert, animated: true)
        case 1:
            let mineVC = MyCreateViewController()
            navigationController?.pushViewController(mineVC, animated: true)
        case 2:
            let mineVC = MyCreateViewController()
            navigationController?.pushViewController(mineVC, animated: true)
        case 3:
           return
        default:
            return

        }
    }
}
