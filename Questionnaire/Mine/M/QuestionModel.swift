//
//  QuestionModel.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/3.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Unrealm



// MARK: - Blank
class Blank: Realmable, Codable {
    required init() {
        (id, question, rightAnswer) = ("", "", "")
        necessary = 0
    }
    
    var id, question, rightAnswer: String
    var necessary: Int

    enum CodingKeys: String, CodingKey {
        case id, question
        case rightAnswer = "right_answer"
        case necessary
    }

    init(id: String, question: String, rightAnswer: String, necessary: Int) {
        self.id = id
        self.question = question
        self.rightAnswer = rightAnswer
        self.necessary = necessary
    }
}

// MARK: Blank convenience initializers and mutators

extension Blank {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Blank.self, from: data)
        self.init(id: me.id, question: me.question, rightAnswer: me.rightAnswer, necessary: me.necessary)
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

    func with(
        id: String? = nil,
        question: String? = nil,
        rightAnswer: String? = nil,
        necessary: Int? = nil
    ) -> Blank {
        return Blank(
            id: id ?? self.id,
            question: question ?? self.question,
            rightAnswer: rightAnswer ?? self.rightAnswer,
            necessary: necessary ?? self.necessary
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Multiple
class Multiple: Realmable, Codable {
    var id, question: String
    var options: [String]
    var rightAnswer: [Int]
    var random, necessary: Int

    enum CodingKeys: String, CodingKey {
        case id, question, options
        case rightAnswer = "right_answer"
        case random, necessary
    }

    init(id: String, question: String, options: [String], rightAnswer: [Int], random: Int, necessary: Int) {
        self.id = id
        self.question = question
        self.options = options
        self.rightAnswer = rightAnswer
        self.random = random
        self.necessary = necessary
    }
    
    required init() {
        (id, question) = ("", "")
        options = []
        rightAnswer = []
        (random, necessary) = (0, 0)
    }
}

// MARK: Multiple convenience initializers and mutators

extension Multiple {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Multiple.self, from: data)
        self.init(id: me.id, question: me.question, options: me.options, rightAnswer: me.rightAnswer, random: me.random, necessary: me.necessary)
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

    func with(
        id: String? = nil,
        question: String? = nil,
        options: [String]? = nil,
        rightAnswer: [Int]? = nil,
        random: Int? = nil,
        necessary: Int? = nil
    ) -> Multiple {
        return Multiple(
            id: id ?? self.id,
            question: question ?? self.question,
            options: options ?? self.options,
            rightAnswer: rightAnswer ?? self.rightAnswer,
            random: random ?? self.random,
            necessary: necessary ?? self.necessary
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Single
class Single: Realmable, Codable {
    var id, question: String
    var options: [String]
    var rightAnswer, random, necessary: Int

    enum CodingKeys: String, CodingKey {
        case id, question, options
        case rightAnswer = "right_answer"
        case random, necessary
    }

    init(id: String, question: String, options: [String], rightAnswer: Int, random: Int, necessary: Int) {
        self.id = id
        self.question = question
        self.options = options
        self.rightAnswer = rightAnswer
        self.random = random
        self.necessary = necessary
    }
    
    required init() {
        (id, question) = ("", "")
        options = []
        (rightAnswer, random, necessary) = (0, 0, 0)
    }
}
