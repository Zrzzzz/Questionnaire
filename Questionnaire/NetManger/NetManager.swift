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
    
    static let URLHEAD = "http://23.234.202.117/api/"
    static let USERID = 1234
    
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
    static func getCreatePaper(type: PaperType, _ completion: @escaping ([MyCreatePaper]) -> Void) {
        var myPapers = [MyCreatePaper]()
        switch type {
        case .quer:
            let param = ["user_id": USERID, "paper_type": 0, "index": -1] as [String : Any]
            AF.request(URLHEAD + "getMyPaper",
                       method: .post,
                       parameters: param,
                       encoding: JSONEncoding.default).responseJSON { (response) in
                        switch response.result {
                        case .success(_):
                            if let data = response.data {
                                let json = try! JSON(data: data)
                                let papers = json["data"]
                                for (_, paperJSON): (String, JSON) in papers {
                                    let paper = try! MyCreatePaper.init(paperJSON)
                                    myPapers.append(paper)
                                }
                                completion(myPapers)
                            }
                        case .failure(let error):
                            print(error)
                        }
            }
            
            
        case .test:
            for i in 1...6 {
                myPapers.append(MyCreatePaper(paperID: Int.random(in: 1..<100000), paperName: "答题\(i)", paperType: .test, status: .notPub, star: 0, number: 0))
            }
            completion(myPapers)
            
        case .vote:
            for i in 1...6 {
                myPapers.append(MyCreatePaper(paperID: Int.random(in: 1..<100000), paperName: "投票\(i)", paperType: .vote, status: .notPub, star: 0, number: 0))
            }
            completion(myPapers)
        }
    }
    
//    static func getPaper(type: Paper.Type)
    
    
    static func postPaper(by paper: Paper, completion: (@escaping (Result<Data, AFError>)->Void)) {
        
        AF.request(URLHEAD + "createPaper",
                   method: .post,
                   parameters: paper,
                   encoder: JSONParameterEncoder.default).responseJSON { (response) in
                    switch response.result {
                    case .success(_):
                        completion(.success(response.data ?? Data()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
        }
    }
    
    static func getStar(completion: (@escaping (Result<String, AFError>)->Void)) {
        AF.request(URLHEAD + "getStar",
                   method: .post,
                   parameters: ["user_id": USERID],
                   encoding: JSONEncoding.default).responseJSON { response in
                    
                    switch response.result {
                    case .success(_):
                        if let data = response.data {
                            let json = try! JSON(data: data)
                            let papers = json["data"]
                            let status = json["status"].intValue
                            for (_, paperJSON) : (String, JSON) in papers {
                                // TODO: do sth
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
        }
    }
    
    static func changeStar(_ paper: MyCreatePaper, completion: (@escaping (Result<JSON, AFError>) -> Void)) {
        AF.request(URLHEAD + "getStar",
                   method: .post,
                   parameters: ["user_id": USERID, "paper_id": paper.paperID, "star": paper.star],
                   encoding: JSONEncoding.default).responseJSON { response in
                    switch response.result {
                    case .success(_):
                        if let data = response.data {
                            let json = try! JSON(data: data)
                            let status = json["status"].intValue
                            // 修改成功
                            if status == 1 {
                                PaperManager.modifyPaper(by: PaperManager.querPaper(by: paper)) { (oldPaper) in
                                    oldPaper.star = json["data"].intValue
                                }
                                completion(.success(json))
                            } else {
                                completion(.failure(.explicitlyCancelled))
                            }
                        } else {
                            // 因为AFError没有啥比较好的enum...
                            completion(.failure(.explicitlyCancelled))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
        }
    }
}

extension AFError {
    enum null {
        case data
    }
}
