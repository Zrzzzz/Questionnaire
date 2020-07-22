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
                myPapers.append(MyJoinPaper(paperID: Int.random(in: 1..<100000), paperName: "Test\(i)", paperType: .quer, startTime: 0, endTime: 0, lastTime: Int(Date().timeIntervalSince1970), status: .overed, score: 99, times: 0))
            }
            for i in 3...4 {
                myPapers.append(MyJoinPaper(paperID: Int.random(in: 1..<100000), paperName: "Test\(i)", paperType: .quer, startTime: 0, endTime: 0, lastTime: Int(Date().timeIntervalSince1970), status: .notPub, score: -1, times: 0))
            }
            for i in 5...6 {
                myPapers.append(MyJoinPaper(paperID: Int.random(in: 1..<100000), paperName: "Test\(i)", paperType: .quer, startTime: 0, endTime: 0, lastTime: Int(Date().timeIntervalSince1970), status: .pubed, score: -2, times: 0))
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
        switch type {
        case .quer:
            let param = ["user_id": userid, "paper_type": 0, "index": 0] as [String : Any]
            AF.request(urlHead + "getMyPaper",
                       method: .post,
                       parameters: param,
                       encoding: JSONEncoding.default).validate().responseJSON { (response) in
                        if let data = response.data {
                            let json = try! JSON(data: data)
                            let papers = json["data"]
                            for (_, paperJSON): (String, JSON) in papers {
                                let paper = try! MyCreatePaper.init(paperJSON)
                                    myPapers.append(paper)
                            }
                            closure(myPapers)
                        }
            }

            
        case .test:
            for i in 1...6 {
                myPapers.append(MyCreatePaper(paperID: Int.random(in: 1..<100000), paperName: "答题\(i)", paperType: .test, status: .notPub, star: 0, number: 0))
            }
            closure(myPapers)
            
        case .vote:
            for i in 1...6 {
                myPapers.append(MyCreatePaper(paperID: Int.random(in: 1..<100000), paperName: "投票\(i)", paperType: .vote, status: .notPub, star: 0, number: 0))
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
    
    
    static func postPaper(by paper: Paper, onSuccess: @escaping ()->()) {
        
        AF.request(urlHead + "createPaper",
                   method: .post,
                   parameters: paper,
                   encoder: JSONParameterEncoder.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let data):
                        print(JSON(data))
                        onSuccess()
                    case .failure(let error):
                        print(error)
                    }
        }
    }
}
