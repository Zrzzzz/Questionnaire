//
//  ItemModel.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

struct ItemModel: Codable {
    let id: Int?
    let title: String?
    let explain: String?
    let type: ItemType?
    let status: ItemStatus?
    let count: Int?
}
