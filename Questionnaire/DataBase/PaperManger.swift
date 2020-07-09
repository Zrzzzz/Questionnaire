//
//  PaperManager.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/5/31.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import RealmSwift

class PaperManager {
    // 设定用户数据库
    static func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        // 使用默认的目录，但是请将文件名替换为
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        UserDefaults.standard.set(username, forKey: "username")
        // 将该配置设置为默认 Realm 配置
        Realm.Configuration.defaultConfiguration = config
        
        print("Realm数据库配置成功, 当前默认用户为 -- " + username)
    }
    
    static func upDateRealmVersion() {
        let username = UserDefaults.standard.string(forKey: "username")!
        
        var version = UserDefaults.standard.integer(forKey: username + ".RealmVersion")
        version += 1
        UserDefaults.standard.set(version, forKey: username + ".RealmVersion") // 保存
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: Realm.Configuration().fileURL, schemaVersion: UInt64(version), migrationBlock: {migration, oldVersion in
            if oldVersion < version {
                // do SomeThing
                // TODO: 暂且不处理, 模型更改的时候才有这个问题
//                migration.enumerateObjects(ofType: <#T##String#>, <#T##block: (MigrationObject?, MigrationObject?) -> Void##(MigrationObject?, MigrationObject?) -> Void#>)
            }
        })
        
        self.deletePaperAll()
        
        print("Realm数据库升级成功, 当前版本为 -- \(version)")
    }
    // 获取数据库
    static private func getDB() -> Realm? {
        var realm: Realm
        do {
            realm = try Realm()
            return realm
        } catch {
            self.upDateRealmVersion()
            do {
                realm = try Realm()
                return realm
            } catch {
                print("升级获取数据库失败")
            }
        }
        return nil
    }
    
    // 存储
    static func savePaper(by paper: Paper) {
        if let realm = getDB() {
            try? realm.write {
                realm.add(paper)
                print(realm.configuration.fileURL)
                print("保存成功")
            }
        }
        
    }
    
    // 获取并更改
    static func modifyPaper(by paper: Paper, _ closure: (Paper) -> Void) {
        if let realm = getDB() {
            if let oldPaper = realm.object(ofType: Paper.self, forPrimaryKey: paper.id) {
                closure(oldPaper)
                
                try? realm.write {
                    realm.add(oldPaper, update: .modified)
                }
            }
        }
        
        
    }
    
    // 更改
    static func update(by paper: Paper) {
        if let realm = getDB() {
            do {
                try realm.write {
                    realm.add(paper, update: .modified)
                }
            } catch {
                print("更新失败")
            }
        }
    }
    
    // 查询
    static func getPapers() -> [Paper] {
        var papers = [Paper]()
        
        if let realm = getDB() {
            let results = realm.objects(Paper.self)
            papers.append(contentsOf: results)
        }
        
        
        return papers
    }
    
    // 转换成CreatePaper
    static func getPaperInCreate() -> [MyCreatePaper] {
        var papers = [Paper]()
        var createPapers = [MyCreatePaper]()
        if let realm = getDB() {
            let results = realm.objects(Paper.self)
            papers.append(contentsOf: results)
        }
        for paper in papers {
            let createPaper = MyCreatePaper(paperID: paper.id, paperName: paper.paperName, star: paper.star, number: 0, status: .notPub, paperType: paper.paperType)
            createPapers.append(createPaper)
        }
        return createPapers
    }
    
    // 条件查询
    static func querPapers(by predicate: NSPredicate) -> [Paper] {
        var papers = [Paper]()
        
        if let realm = getDB() {
            let results = realm.objects(Paper.self).filter(predicate)
            papers.append(contentsOf: results)
        }
        
        
        
        return papers
    }
    
    // 删除
    static func deletePaper(by paper: Paper) {
        if let realm = getDB() {
            do {
                print(realm.configuration.fileURL)
                try realm.write {
                    realm.delete(paper)
                }
            } catch {
                print("删除失败")
            }
        }
    }
    
    // 条件删除
    static func deletePapers(by predicate: NSPredicate){
        
        if let realm = getDB() {
            let results = realm.objects(Paper.self).filter(predicate)
            do {
                try realm.write {
                    print(realm.configuration.fileURL)
                    // i should quote it but not pass its value
                    for i in 0..<results.count {
                        realm.delete(results[i])
                    }
                }
            } catch {
                print("删除失败")
            }
        }
        
    }
    
    // 删除所有
    static func deletePaperAll() {
        if let realm = getDB() {
            do {
                try realm.write {
                    realm.deleteAll()
                }
            } catch {
                print("删除失败")
            }
        }
    }
}
