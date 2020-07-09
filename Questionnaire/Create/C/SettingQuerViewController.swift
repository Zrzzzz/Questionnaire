//
//  SettingQuerViewController.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/6.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Eureka

class SettingQuerViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< SwitchRow("randomTitle") {
                $0.title = "题目是否乱序"
            }
            
            <<< SwitchRow("randomSelection") {
                $0.title = "选项是否乱序"
            }
            
            <<< IntRow("allowAnswerCount") {
                $0.title = "允许作答次数"
            }
            
            <<< PushRow<String>("randomQuestionSetting") {
                $0.title = "随机题目设置"
                $0.value = "未设置"
        }
    }
    
}
