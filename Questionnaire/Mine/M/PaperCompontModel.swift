//
//  PaperCompontModel.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/1.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Unrealm

enum MyType {
    case join, create
}

enum PaperType: Int, Codable, RealmableEnumInt {
    case quer = 0
    case test = 1
    case vote = 2
    
    func string() -> String {
        switch self {
        case .quer: return "问卷"
        case .test: return "答题"
        case .vote: return "投票"
        }
    }
}

enum PaperStatus: Int, Codable, RealmableEnum {
    case notPub = 2
    case pubed = 0
    case overed = 1
    
    func string() -> String {
        switch self {
        case .notPub:
            return "未发布"
        case .pubed:
            return "已发布"
        case .overed:
            return "已结束"
        }
    }
}

enum QuesType {
    case single, mutliple, blank
}
