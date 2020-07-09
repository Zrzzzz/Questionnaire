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

class NetManager: UIView {

    static func getJoinPaper(type: PaperType) -> [MyJoinPaper] {
        
        return []
    }
    
    // 除了网络请求需要加上本地缓存的CreatedPaper
    static func getCreatePaper(type: PaperType) -> [MyCreatePaper] {
        let userid = "ZZX"
        var myPapers = [MyCreatePaper]()
        switch type {
        case .quer:
            myPapers.append(contentsOf: PaperManager.getPaperInCreate())
            let param = ["user_id": userid, "paper_type": 0, "index": -1] as [String : Any]
            AF.request("http://23.234.202.117/api/getMyPart",
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
                        }
            }
            
        case .test:
            for i in 1...6 {
                myPapers.append(MyCreatePaper(paperID: UUID().uuidString, paperName: "答题\(i)", star: 1, number: 999, status: .notPub, paperType: .test))
            }
        case .vote:
            for i in 1...6 {
                myPapers.append(MyCreatePaper(paperID: UUID().uuidString, paperName: "投票\(i)", star: 1, number: 999, status: .notPub, paperType: .vote))
            }
        }

        return myPapers
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
}
