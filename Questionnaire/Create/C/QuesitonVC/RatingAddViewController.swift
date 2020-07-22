//
//  RatingAddViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/14.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Eureka

class RatingAddViewController: FormViewController {
    var delegate: EditPaperDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            Section() { section in
                section.header = self.sectionHeader(title: "题面")
            }
            <<<  TextRow("title") {
                $0.placeholder = "输入题干"
            }
            
            <<< PushRow<Int>("step") {
                $0.title = "分值上限"
                $0.options = [3, 4, 5, 6, 7]
                $0.value = 3
                $0.selectorTitle = "选择级数"
            }

            <<< TextRow("min") {
                $0.title = "最小端显示"
            }
            
            <<< TextRow("max") {
                $0.title = "最大端显示"
            }
            
            +++ Section() { section in
                section.header = self.sectionHeader(title: "更多设置")
            }
            
            <<< PushRow<String>("style") {
                $0.title = "选项样式    "
                $0.options = ["圆点", "星星"]
                $0.value = "圆点"
            }
            
            <<< PushRow<String>("mustAns") {
                $0.title = "是否必答"
                $0.options = ["是", "否"]
                $0.value = "是"
                $0.selectorTitle = "设置必答"
            }
        
            <<< PushRow<String>("condition") {
                $0.title = "显示条件"
                $0.value = "未设置"
            }
            <<< PushRow<String>("jmp") {
                $0.title = "跳转设置"
                $0.value = "未设置"
        }
            +++ ButtonRow() {
                $0.title = "保存"
            }.onCellSelection({ (cell, row) in
//                if let title = (self.form.rowBy(tag: "title") as! TextRow).value,
//                    let score = (self.form.rowBy(tag: "score") as! IntRow).value {
//                    let blank = Blank(id: UUID().uuidString, question: title, rightAnswer: self.getRightAns(), necessary: self.getNess(), score: score)
//                    self.delegate?.paper?.paperQuestion.blank.append(blank)
//                }
//                let vcCount = self.navigationController?.viewControllers.count
//                self.navigationController?.popToViewController((self.navigationController?.viewControllers[vcCount! - 3])!, animated: true)
            })
        
    }
    
    private func getRightAns() -> String? {
        if let ans = (self.form.rowBy(tag: "rightAns") as! TextRow).value {
            return ans
        }
        return nil
    }
    
    private func getNess() -> Int {
        if let str = (self.form.rowBy(tag: "mustAns") as! PushRow<String>).value {
            switch str {
            case "否":
                return 0
            default:
                return 1
            }
        }
        return 1
    }
    
    private func sectionHeader(title: String) -> HeaderFooterView<UIView> {
        let view = HeaderFooterView<UIView>(.callback({ () -> UIView in
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            label.text = "  \(title)"
            label.font = .boldSystemFont(ofSize: 20)
            
            return label
        }))
        
        return view
    }
    
    
    
}
