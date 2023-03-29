//
//  MultipleAddViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/7.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Eureka

class MultipleAddViewController: FormViewController {
    enum Status {
        case add, update
    }
    
    var status: Status = .add
    var multi: Multiple?
    var delegate: EditPaperDelegate?
    
    /// 用于Update
    /// - Parameters:
    ///   - ques: 现有题目
    convenience init(by multi: Multiple) {
        self.init()
        self.status = .update
        self.multi = multi
    }
    
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
            <<< MultipleSelectorRow<String>("rightAns") {
                $0.title = "设置答案"
                $0.value = ["未设置"]
            }.onCellSelection({ (cell, row) in
                row.options = self.getOptions()
            }).cellUpdate({ (cell, row) in
                if row.value == ["未设置"] {
                    row.value = []
                }
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
                    // create multi
                    let multi = Multiple(id: self.multi?.id ?? UUID().uuidString, question: title, options: self.getOptions(), rightAnswer: self.getRightAns(), random: 0, necessary: self.getNess(), score: score, signed: 0, signedID: 0, sign: [])
                    // add or update
                    if self.status == .add {
                        self.delegate?.paper?.paperQuestion.multiple.append(multi)
                    } else {
                        // 先找到下标
                        let index = self.delegate?.paper?.paperQuestion.multiple.firstIndex(where: {$0.id == self.multi?.id})
                        self.delegate?.paper?.paperQuestion.multiple[index!] = multi
                    }
                }
                if self.status == .add {
                    let vcCount = self.navigationController?.viewControllers.count
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[vcCount! - 3])!, animated: true)
                    // 后退两个VC, 跳过了题目中心的页面
                } else {
                    // update模式的话只需要到编辑页面即可
                    self.navigationController?.popViewController(animated: true)
                }
            })
        
        // update的话, 这里和single很像
        if self.status == .update {
            (self.form.rowBy(tag: "title") as! TextRow).value = multi?.question
            // 操作一下, 去掉默认的row, 然后再插入
            var multiSection = self.form.sectionBy(tag: "selectionSection") as! MultivaluedSection
            let options = (multi?.options)!
            multiSection.remove(at: 0)
            for i in 0..<(multi?.options.count)! {
                multiSection.insert(TextRow() {
                    $0.value = options[(multi?.options.count)! - i - 1]
                }, at: 0)
            }
            
            var rightAns = Set<String>()
            for i in multi!.rightAnswer! {
                rightAns.insert(multi!.options[i])
            }
            (self.form.rowBy(tag: "rightAns") as! MultipleSelectorRow).value = rightAns
            (self.form.rowBy(tag: "mustAns") as! PushRow<String>).value = multi?.necessary == 0 ? "否" : "是"
            (self.form.rowBy(tag: "score") as! IntRow).value = multi?.score
        }
        
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
    
    private func getRightAns() -> [Int]? {
        let options = getOptions()
        var arr = Array<Int>()
        if let anses = (self.form.rowBy(tag: "rightAns") as! MultipleSelectorRow<String>).value {
            for ans in anses {
                arr.append(options.firstIndex(of: ans)!)
            }
            return arr
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
