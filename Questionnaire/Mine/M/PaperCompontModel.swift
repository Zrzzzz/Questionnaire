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

enum PaperType: Int, Codable, RealmableEnum {
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
    
    func imageName() -> String {
        switch self {
        case .quer: return "minevc_quer"
        case .test: return "minevc_test"
        case .vote: return "minevc_vote"
        }
    }
}

enum PaperStatus: Int, Codable, Comparable, RealmableEnum {
    // FIXME: 可能要用123
    case pubed = 0
    case overed = 1
    case notPub = 2
    
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
    
    func imageName() -> String {
        switch self {
        case .notPub:
            return "minevc_status_notPub"
        case .pubed:
            return "minevc_status_pubed"
        case .overed:
            return "minevc_status_overed"
        }
    }
    
    static func < (lhs: PaperStatus, rhs: PaperStatus) -> Bool {
        if lhs == .notPub && (rhs == .pubed || rhs == .overed) {
            return true
        } else if lhs == .pubed && rhs == .overed {
            return true
        } else {
            return false
        }
    }
}



enum QuesType {
    case single, multiple, blank, rating
}
