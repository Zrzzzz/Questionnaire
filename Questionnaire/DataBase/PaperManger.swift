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
            }
        })
        
        print("Realm数据库升级成功, 当前版本为 -- \(version)")
    }
    
    static func savePaper(by paper: Paper) {
        let realm = try? Realm()
        
        try? realm?.write {
            realm?.add(paper)
        }
        
    }
    
    static func modifyPaper(by paper: Paper, _ closure: (Paper) -> Void) {
        let realm = try? Realm()
        
        if let oldPaper = realm?.object(ofType: Paper.self, forPrimaryKey: paper.id) {
            closure(oldPaper)
            
            try? realm?.write {
                realm?.add(oldPaper, update: .modified)
            }
        }
    }
    
    static func getPapers() -> [Paper] {
        var papers = [Paper]()
        
        let realm = try? Realm()
        if let results = realm?.objects(Paper.self) {
            papers.append(contentsOf: results)
        }
    
        return papers
    }
    
    static func querPapers(by predicate: NSPredicate) -> [Paper] {
        var papers = [Paper]()
        
        let realm = try? Realm()
        if let results = realm?.objects(Paper.self).filter(predicate) {
            papers.append(contentsOf: results)
        }
        
        return papers
    }
    
    static func deletePaper(by paper: Paper) {
        do {
            let realm = try? Realm()
            
            try realm?.write {
                realm?.delete(paper)
            }
            print(realm?.configuration.fileURL)
        } catch {
            fatalError()
        }
    }
}
