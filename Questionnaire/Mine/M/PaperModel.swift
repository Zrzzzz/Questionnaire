//
//  PaperModel.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Unrealm


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let paper = try Paper(json)

// MARK: - Paper
class Paper: Realmable, Codable {
    var id: Int
    var paperName: String
    var paperComment: String?
    var startTime, endTime, timeLimit: Int
    var paperType: PaperType
    var needCheck: Int
    
    var paperQuestion: PaperQuestion
    var random, times, star: Int
    
    // 主键
    static func primaryKey() -> String? {
        return "id"
    }
    // 索引, 提高速度
    static func indexedProperties() -> [String] {
        return ["id", "paperName"]
    }
    

    private enum CodingKeys: String, CodingKey {
        case id
        case paperName = "paper_name"
        case paperComment = "paper_comment"
        case startTime = "start_time"
        case endTime = "end_time"
        case paperType = "paper_type"
        case paperQuestion = "paper_question"
        case random, times, star
        case timeLimit = "time_limit"
        case needCheck = "need_check"
    }
    
    required init() {
        (id, paperName) = (Int.random(in: 1..<Int.max), "")
        paperType = PaperType.quer
        paperComment = nil
        (startTime, endTime, random, times, timeLimit, needCheck) = (0, 0, 0, 0, -1, 0)
        paperQuestion = PaperQuestion()
        star = 0
    }

    required init(id: Int, paperName: String, paperComment: String?, startTime: Int, endTime: Int, paperType: PaperType, paperQuestion: PaperQuestion, random: Int, times: Int, timeLimit: Int, needCheck: Int, star: Int) {
        self.id = id
        self.paperName = paperName
        self.paperComment = paperComment
        self.startTime = startTime
        self.endTime = endTime
        self.paperType = paperType
        self.paperQuestion = paperQuestion
        self.random = random
        self.times = times
        self.timeLimit = timeLimit
        self.needCheck = needCheck
        self.star = star
    }
    
}


// MARK: Paper convenience initializers and mutators

extension Paper {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Paper.self, from: data)
        self.init(id: me.id, paperName: me.paperName, paperComment: me.paperComment ?? "", startTime: me.startTime, endTime: me.endTime, paperType: me.paperType, paperQuestion: me.paperQuestion, random: me.random, times: me.times, timeLimit: me.timeLimit, needCheck: me.needCheck, star: me.star)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

