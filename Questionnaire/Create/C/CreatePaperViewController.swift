//
//  CreatePaperViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

//import UIKit
import Eureka
import SwiftDate
import SwiftyJSON
import Realm

class CreatePaperViewController: FormViewController {
    
    var type: PaperType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = type.string()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(back))
        
        form
            
            
            +++ Section(header: "设定你的" + (title ?? ""), footer: nil)
            <<< TextRow("title") {
                $0.title = type.string() + "名称"
            }
            <<< TextRow("explain") {
                $0.title = type.string() + "说明"
//                $0.placeholder = "选填"
            }
            <<< DateTimeInlineRow("startTime") {
                $0.title = "开始时间"
                $0.value = Date()
            }
            .onChange { [weak self] row in
                let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "endTime")
                if row.value?.compare(endRow.value!) == .orderedDescending {
                    endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                    endRow.cell!.backgroundColor = .white
                    endRow.updateCell()
                }
            }
            
            <<< DateTimeInlineRow("endTime"){
                $0.title = "结束时间"
                $0.value = Date().addingTimeInterval(60 * 60)
            }
            .onChange { [weak self] row in
                let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "startTime")
                if row.value?.compare(startRow.value!) == .orderedAscending {
                    row.cell!.backgroundColor = .red
                }
                else{
                    row.cell!.backgroundColor = .white
                }
                row.updateCell()
            }

            
            +++ Section()
            <<< ButtonRow("check") {
                $0.title = "确认"
            }
            .onCellSelection { cell, row in
                
                if let title = (self.form.rowBy(tag: "title") as! TextRow).value ,
                    
                    let start = (self.form.rowBy(tag: "startTime") as! DateTimeInlineRow).value,
                    let end = (self.form.rowBy(tag: "endTime") as! DateTimeInlineRow).value {
                    let explain = (self.form.rowBy(tag: "explain") as! TextRow).value ?? ""
                    let newPaper = Paper(id: Int.random(in: 1..<100000), paperName: title, paperComment: explain, startTime: Int(start.timeIntervalSince1970), endTime: Int(end.timeIntervalSince1970), paperType: self.type, paperQuestion: PaperQuestion(), random: 0, times: 0, timeLimit: 0, needCheck: 0, star: 0)
                    PaperManager.savePaper(by: newPaper)

                    let editVC = EditPaperViewController()
                    editVC.paper = newPaper
                    
                    self.navigationController?.pushViewController(editVC, animated: true)
                    return
                }
                let alert = UIAlertController(title: "错误", message: "请输入标题", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let action2 = UIAlertAction(title: "确定", style: .default, handler: nil)
                alert.addAction(action1)
                alert.addAction(action2)
                
                self.present(alert, animated: true)
        }
        
        
    }
    
    
    @objc fileprivate func back() {
//        let vcCount = self.navigationController?.viewControllers.count
//        self.navigationController?.popToViewController((self.navigationController?.viewControllers[vcCount! - 3])!, animated: true)

        self.navigationController?.popToRootViewController(animated: true)
    }
}
