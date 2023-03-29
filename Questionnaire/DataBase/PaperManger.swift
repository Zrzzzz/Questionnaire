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
                realm.add(paper, update: .modified)
                print(realm.configuration.fileURL!)
                print("保存成功")
            }
        }
    }
    
    static func savePapers(by papers: [Paper]) {
        if let realm = getDB() {
            try? realm.write {
                realm.add(papers)
                print(realm.configuration.fileURL!)
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
                    print(realm.configuration.fileURL!)
                    realm.add(paper, update: .modified)
                }
            } catch {
                print("更新失败")
            }
        }
    }
    
    // 查询
    static func querPapers() -> [Paper] {
        var papers = [Paper]()
        
        if let realm = getDB() {
            let results = realm.objects(Paper.self)
            papers.append(contentsOf: results)
        }
        
        
        return papers
    }
    
    // 利用createPaper查询
    static func querPaper(by paper: MyCreatePaper) -> Paper {
        return querPapers(by: NSPredicate(format: "id == %d", paper.paperID))[0]
    }
    
    // TODO: 暂时用这个查询, 之后删掉
    static func querPaper(by paper: MyJoinPaper) -> Paper {
        return querPapers(by: NSPredicate(format: "paperName like %@", paper.paperName))[0]
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
                print(realm.configuration.fileURL!)
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
                    print(realm.configuration.fileURL!)
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
            let results = realm.objects(Paper.self)
            do {
                try realm.write {
                    print(realm.configuration.fileURL!)
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
}

//MARK: - for MyCreatePaper
extension PaperManager {
    // 存储
    static func saveMyCreatePaper(by paper: MyCreatePaper) {
        if let realm = getDB() {
            try? realm.write {
                realm.add(paper, update: .all)
                print(realm.configuration.fileURL!)
                print("保存成功")
            }
        }
    }
    
    static func saveMyCreatePapers(by papers: [MyCreatePaper]) {
        if let realm = getDB() {
            try? realm.write {
                realm.add(papers)
                print(realm.configuration.fileURL!)
                print("保存成功")
            }
        }
    }
    
    // 获取CreatePaper
    static func getPaperInCreate(type: PaperType) -> [MyCreatePaper] {
        var createPapers = [MyCreatePaper]()
        
       
        if let realm = getDB() {
            //获取现有Paper里未发布的
            let papers = realm.objects(Paper.self).filter { (paper) -> Bool in
                paper.paperType == type
            }
            
            createPapers.append(contentsOf: papers.map(changePaperToCreatePaper(paper:)).sorted(by: {
                $0.paperName < $1.paperName
            }))
            
            // 获取MyCreate
            let results = realm.objects(MyCreatePaper.self).filter("paperType == \(type.rawValue)").sorted(by: [SortDescriptor(keyPath: "status"), SortDescriptor(keyPath: "paperName")])
            
            createPapers.append(contentsOf: results)
        }
        return createPapers
    }
    
    static func changePaperToCreatePaper(paper: Paper) -> MyCreatePaper {
        return MyCreatePaper(paperID: paper.id, paperName: paper.paperName, paperType: paper.paperType, status: .notPub, star: 0, number: 0)
    }
    
    static func changeCreatePaperToPaper(paper: MyCreatePaper) -> Paper {
        return querPaper(by: paper)
    }
    
    // 删除
    static func deleteMyCreate(by paper: MyCreatePaper) {
        if let realm = getDB() {
            do {
                print(realm.configuration.fileURL!)
                try realm.write {
                    realm.delete(paper)
                }
            } catch {
                print("删除失败")
            }
        }
    }
    
    static func test() {
        let realm = getDB()
        let res = realm?.objects(MyCreatePaper.self).filter("paperName contains[c] 'test'")
        for i in res! {
            print(i)
        }
    }
}
