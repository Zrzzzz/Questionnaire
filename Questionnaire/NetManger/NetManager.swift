//
//  NetManager.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/7/4.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

let jsonStr = "{\"status\": 0,     \"data\": [{         \"paper_id\": \"UUID\",         \"paper_name\": \"WWW\",         \"last_time\": 12345,         \"paper_type\": 0     }, {         \"paper_id\": \"UUID\",         \"paper_name\": \"WWW\",         \"start_time\": 12345,         \"end_time\": 12345,         \"score\": -1,         \"times\": 0,         \"paper_type\": 0     }] }"

class NetManager {
    static let urlHead = "http://23.234.202.117/api/"
    
    static func getJoinPaper(type: PaperType) -> [MyJoinPaper] {
        var myPapers = [MyJoinPaper]()
        switch type {
        case .quer:
            for i in 1...2 {
                myPapers.append(MyJoinPaper(paperID: Int.random(in: 1..<Int.max), paperName: "问卷\(i)", startTime: 0, endTime: 0, score: 99, status: .overed, paperType: .quer, lastTime: Int(Date().timeIntervalSince1970), times: 0))
            }
            for i in 3...4 {
                myPapers.append(MyJoinPaper(paperID: Int.random(in: 1..<Int.max), paperName: "问卷\(i)", startTime: 0, endTime: 0, score: -1, status: .notPub, paperType: .quer, lastTime: Int(Date().timeIntervalSince1970), times: 0))
            }
            for i in 5...6 {
                myPapers.append(MyJoinPaper(paperID: Int.random(in: 1..<Int.max), paperName: "问卷\(i)", startTime: 0, endTime: 0, score: -2, status: .pubed, paperType: .quer, lastTime: Int(Date().timeIntervalSince1970), times: 0))
            }
        default:
            print("nothing")
        }
        
        return myPapers
    }
    
    // 除了网络请求需要加上本地缓存的CreatedPaper
    static func getCreatePaper(type: PaperType, _ closure: @escaping ([MyCreatePaper]) -> Void) {
        let userid = 1234
        var myPapers = [MyCreatePaper]()
//        let group = DispatchGroup()
        switch type {
        case .quer:
            myPapers.append(contentsOf: PaperManager.getPaperInCreate())
            let param = ["user_id": userid, "paper_type": 0, "index": -1] as [String : Any]
//            group.enter()
            AF.request("http://23.234.202.117/api/getMyPaper",
                       method: .post,
                       parameters: param,
                       encoding: JSONEncoding.default).validate().responseJSON { (response) in
                        if let data = response.data {
                            let json = try! JSON(data: data)
                            let papers = json["data"]
                            for (_, paperJSON): (String, JSON) in papers {
                                let paper = try! MyCreatePaper.init(paperJSON.description)
                                    myPapers.append(paper)
                            }
//                            group.leave()
                            closure(myPapers)
                        }
            }

            
        case .test:
            for i in 1...6 {
                myPapers.append(MyCreatePaper(paperID: Int.random(in: 1..<Int.max), paperName: "答题\(i)", star: 1, number: 999, status: .notPub, paperType: .test))
            }
            closure(myPapers)
            
        case .vote:
            for i in 1...6 {
                myPapers.append(MyCreatePaper(paperID: Int.random(in: 1..<Int.max), paperName: "投票\(i)", star: 1, number: 999, status: .notPub, paperType: .vote))
            }
            closure(myPapers)
        }
    }
    
    static func testData() {
        let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        var joinPaper: [MyJoinPaper] = []
        let json = try! JSON(data: jsonData!)
        let papers = json["data"]
        for (_, paperJSON): (String, JSON) in papers {
            let paper = try! MyJoinPaper.init(paperJSON.description)
            joinPaper.append(paper)
        }
        
        print(joinPaper)
    }
    
    static func test() {
        let param = ["user_id": 1234, "paper_type": 0, "index": 0] as [String : Any]
//        AF.request(urlHead + "getMyPart",
//                   method: .post,
//                   parameters: param,
//                   encoding: JSONEncoding.default).validate().responseJSON { res in
//                    if let data = res.data {
//                        print(JSON(data))
//                        print("请求2")
//                    }
//        }
        
//        let paper = Paper(id: "hahhahaha", paperName: "woaawda", paperComment: "yoyoyoyo", startTime: 0, endTime: 0, paperType: .quer, paperQuestion: PaperQuestion(), random: 0, times: 1, timeLimit: -1, needCheck: 0, star: 0)
//        postData(by: paper)
    }
    
    static func postData(by paper: Paper) {
        let tmp = try! paper.jsonData()
        var data = try? JSONSerialization.jsonObject(with: tmp, options: []) as? [String: Any]
        data?["user_id"] = 1234
        
        AF.request(urlHead + "createPaper",
                   method: .post,
                   parameters:data,
                   encoding: JSONEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(JSON(value))
            case .failure(let error):
                print(error)
            }
        }
    }
}
