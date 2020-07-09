//
//  SingleAddViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/7.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Eureka

class SingleAddViewController: FormViewController {
    
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
            +++
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete]) {
                $0.tag = "selectionSection"
                $0.addButtonProvider = { section in
                    return ButtonRow(){
                        $0.title = "添加选项"
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return TextRow() {
                        $0.placeholder = "选项内容"
                    }
                }
                $0 <<< TextRow() {
                    $0.placeholder = "选项内容"
                }
            }
            
            +++ Section() { section in
                section.header = self.sectionHeader(title: "更多设置")
            }
            
            <<< PushRow<String>("mustAns") {
                $0.title = "是否必答"
                $0.options = ["是", "否"]
                $0.value = "是"
                $0.selectorTitle = "设置必答"
            }
            <<< PushRow<String>("rightAns") {
                $0.title = "设置答案"
                $0.value = "未设置"
            }.onCellSelection({ (cell, row) in
                row.options = self.getOptions()
                })
            <<< IntRow("score") {
                $0.title = "设置分值"
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
                if let title = (self.form.rowBy(tag: "title") as! TextRow).value,
                    let score = (self.form.rowBy(tag: "score") as! IntRow).value {
                    let single = Single(id: UUID().uuidString, question: title, options: self.getOptions(), rightAnswer: self.getRightAns(), random: 0, necessary: self.getNess(), score: score)
                    self.delegate?.paper?.paperQuestion.single.append(single)
                }
                let vcCount = self.navigationController?.viewControllers.count
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[vcCount! - 3])!, animated: true)
            })
        
    }
    private func getOptions() -> [String] {
        var arr = Array<String>()
        if let section = self.form.sectionBy(tag: "selectionSection") {
            for row in section.allRows {
                if let value = row.baseValue {
                    arr.append(value as! String)
                }
            }
        }
        return arr
    }
    
    private func getRightAns() -> Int {
        if let rightAns = (self.form.rowBy(tag: "rightAns") as! PushRow<String>).value {
            return self.getOptions().firstIndex(of: rightAns)!
        }
        return 0
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
