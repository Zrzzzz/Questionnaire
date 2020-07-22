//
//  MyPaperModel.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/2.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import SwiftyJSON
import Unrealm

// MARK: - MyJoinPaper
struct MyJoinPaper: Realmable, Hashable, Codable {
    static func primaryKey() -> String? {
        return "paperID"
    }
    
    init() {
        paperID = Int.random(in: 1..<100000)
        (startTime, endTime, score, lastTime, times) = (nil, nil, nil, nil, nil)
        paperName = ""
        status = .notPub
        paperType = .quer
    }
    
    init(paperID: Int, paperName: String, paperType: PaperType, startTime: Int, endTime: Int, lastTime: Int, status: PaperStatus, score: Int, times: Int) {
        self.paperID = paperID
        self.paperName = paperName
        self.paperType = paperType
        self.startTime = startTime
        self.endTime = endTime
        self.lastTime = lastTime
        self.status = status
        self.score = score
        self.times = times
    }
    
    var paperID: Int
    var paperName: String
    var startTime, endTime, score: Int?
    var status: PaperStatus
    var paperType: PaperType
    var lastTime, times: Int?

    enum CodingKeys: String, CodingKey {
        case paperID = "paper_id"
        case paperName = "paper_name"
        case startTime = "start_time"
        case endTime = "end_time"
        case paperType = "paper_type"
        case status
        case score
        case lastTime = "last_time"
        case times
    }
}

// MARK: MyJoinPaper convenience initializers and mutators

extension MyJoinPaper {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MyJoinPaper.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    init(_ json: JSON, using encoding: String.Encoding = .utf8) throws {
        try self.init(json.description, using: encoding)
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - MyCreatePaper
struct MyCreatePaper: Realmable, Hashable, Codable {
    
    var paperID: Int
    var paperName: String
    var star, number: Int
    var status: PaperStatus
    var paperType: PaperType

    enum CodingKeys: String, CodingKey {
        case paperID = "paper_id"
        case paperName = "paper_name"
        case status, star, number
        case paperType = "paper_type"
    }
    
    static func primaryKey() -> String? {
        return "paperID"
    }
    
    init() {
        paperID = Int.random(in: 1..<100000)
        paperName = ""
        (star, number) = (0, 0)
        status = .pubed
        paperType = .quer
    }
    
    init(paperID: Int, paperName: String, paperType: PaperType, status: PaperStatus, star: Int, number: Int) {
        self.paperID = paperID
        self.paperName = paperName
        self.paperType = paperType
        self.status = status
        self.star = star
        self.number = number
    }
}

// MARK: MyCreatePaper convenience initializers and mutators

extension MyCreatePaper {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MyCreatePaper.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    init(_ json: JSON, using encoding: String.Encoding = .utf8) throws {
        try self.init(json.description, using: encoding)
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

