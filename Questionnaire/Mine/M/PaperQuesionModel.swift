//
//  QuestionModel.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/2.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Unrealm

// MARK: - PaperQuestion
class PaperQuestion: Realmable, Codable {
    var single: [Single]
    var multiple: [Multiple]
    var blank: [Blank]

    init(single: [Single], multiple: [Multiple], blank: [Blank]) {
        self.single = single
        self.multiple = multiple
        self.blank = blank
    }
    
    required init() {
        self.single = []
        self.multiple = []
        self.blank = []
    }
}

// MARK: PaperQuestion convenience initializers and mutators

extension PaperQuestion {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PaperQuestion.self, from: data)
        self.init(single: me.single, multiple: me.multiple, blank: me.blank)
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
