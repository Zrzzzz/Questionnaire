//
//  BlankAddViewController.swift
//  blanktionnaire
//
//  Created by Zr埋 on 2020/7/7.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Eureka

class BlankAddViewController: FormViewController {
    enum Status {
        case add, update
    }
    
    var status: Status = .add
    var blank: Blank?
    var delegate: EditPaperDelegate?
    
    /// 用于Update
    /// - Parameters:
    ///   - blank: 现有题目
    convenience init(by blank: Blank) {
        self.init()
        self.status = .update
        self.blank = blank
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
            
            +++ Section() { section in
                section.header = self.sectionHeader(title: "更多设置")
            }
            
            <<< PushRow<String>("mustAns") {
                $0.title = "是否必答"
                $0.options = ["是", "否"]
                $0.value = "是"
                $0.selectorTitle = "设置必答"
            }
            <<< TextRow("rightAns") {
                $0.placeholder = "设置答案(不需要则不填)"
            }
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
                    // 本来放在下面的if else语句中, 但是这样的话能够省一点, 如果self.blank.id 为空也就是创建状态了
                    let blank = Blank(id: self.blank?.id ?? UUID().uuidString, question: title, rightAnswer: self.getRightAns(), necessary: self.getNess(), score: score, signed: 0, signedID: 0, sign: [])
                    if self.status == .add {
                        self.delegate?.paper?.paperQuestion.blank.append(blank)
                    } else {
                        let index = self.delegate?.paper?.paperQuestion.blank.firstIndex(where: {$0.id == self.blank?.id})
                        self.delegate?.paper?.paperQuestion.blank[index!] = blank
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
        
        if self.status == .update {
            (self.form.rowBy(tag: "title") as! TextRow).value = blank?.question
                        
            (self.form.rowBy(tag: "rightAns") as! TextRow).value = blank?.rightAnswer
            (self.form.rowBy(tag: "mustAns") as! PushRow<String>).value = blank?.necessary == 0 ? "否" : "是"
            (self.form.rowBy(tag: "score") as! IntRow).value = blank?.score
        }
        
        
    }
    
    private func getRightAns() -> String? {
        if let ans = (self.form.rowBy(tag: "rightAns") as! TextRow).value {
            return ans
        }
        return ""
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
