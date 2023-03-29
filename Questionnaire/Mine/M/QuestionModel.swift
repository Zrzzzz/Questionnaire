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
        (id, question, rightAnswer) = ("", "", nil)
        necessary = 0
        score = 0
        (signed, signedID, sign) = (0, 0, [])
    }
    
    var id, question: String
    var rightAnswer: String?
    var necessary, score: Int
    var signed, signedID: Int
    var sign: [Sign]

    enum CodingKeys: String, CodingKey {
        case id, question
        case rightAnswer = "right_answer"
        case necessary
        case score
        case sign, signed
        case signedID = "signed_id"
    }

    init(id: String, question: String, rightAnswer: String?, necessary: Int, score: Int, signed: Int, signedID: Int, sign: [Sign]) {
        self.id = id
        self.question = question
        self.rightAnswer = rightAnswer
        self.necessary = necessary
        self.score = score
        self.signed = signed
        self.signedID = signedID
        self.sign = sign
    }
}

// MARK: Blank convenience initializers and mutators

extension Blank {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Blank.self, from: data)
        self.init(id: me.id, question: me.question, rightAnswer: me.rightAnswer ?? "", necessary: me.necessary, score: me.score, signed: me.signed, signedID: me.signedID, sign: me.sign)
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

// MARK: - Multiple
class Multiple: Realmable, Codable {
    var id, question: String
    var options: [String]
    var rightAnswer: [Int]?
    var random, necessary, score: Int
    var signed, signedID: Int
    var sign: [Sign]

    enum CodingKeys: String, CodingKey {
        case id, question, options
        case rightAnswer = "right_answer"
        case random, necessary
        case score
        case signed, sign
        case signedID = "signed_id"
    }

    init(id: String, question: String, options: [String], rightAnswer: [Int]?, random: Int, necessary: Int, score: Int, signed: Int, signedID: Int, sign: [Sign]) {
        self.id = id
        self.question = question
        self.options = options
        self.rightAnswer = rightAnswer
        self.random = random
        self.necessary = necessary
        self.score = score
        self.signed = signed
        self.signedID = signedID
        self.sign = sign
    }
    
    required init() {
        (id, question) = ("", "")
        options = []
        rightAnswer = nil
        (random, necessary, score) = (0, 0, 0)
        (signed, signedID, sign) = (0, 0, [])
    }
}

// MARK: Multiple convenience initializers and mutators

extension Multiple {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Multiple.self, from: data)
        self.init(id: me.id, question: me.question, options: me.options, rightAnswer: me.rightAnswer ?? [], random: me.random, necessary: me.necessary, score: me.score, signed: me.signed, signedID: me.signedID, sign: me.sign)
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

// MARK: - Single
class Single: Realmable, Codable {
    var id, question: String
    var options: [String]
    var rightAnswer: Int?
    var random, necessary, score: Int
    var signed, signedID: Int
    var sign: [Sign]

    enum CodingKeys: String, CodingKey {
        case id, question, options
        case rightAnswer = "right_answer"
        case random, necessary
        case score
        case signed, sign
        case signedID = "signed_id"
    }

    init(id: String, question: String, options: [String], rightAnswer: Int?, random: Int, necessary: Int, score: Int, signed: Int, signedID: Int, sign: [Sign]) {
        self.id = id
        self.question = question
        self.options = options
        self.rightAnswer = rightAnswer
        self.random = random
        self.necessary = necessary
        self.score = score
        self.signed = signed
        self.signedID = signedID
        self.sign = sign
    }
    
    required init() {
        (id, question) = ("", "")
        options = []
        (rightAnswer, random, necessary, score) = (nil, 0, 0, 0)
        (signed, signedID, sign) = (0, 0, [])
    }
}

// MARK: Single convenience initializers and mutators

extension Single {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Single.self, from: data)
        self.init(id: me.id, question: me.question, options: me.options, rightAnswer: me.rightAnswer ?? 0, random: me.random, necessary: me.necessary, score: me.score, signed: me.signed, signedID: me.signedID, sign: me.sign)
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

struct Sign: Realmable, Codable {
    init() {
        signId = 0
        optionIndex = []
    }
    
    var signId: Int
    var optionIndex: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case signId = "sign_id"
        case optionIndex = "option_index"
    }
    
}
