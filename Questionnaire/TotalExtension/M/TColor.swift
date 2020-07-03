//
//  TColor.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

public struct TColor {
    static let main = UIColor.init { trainCollection -> UIColor in
        return trainCollection.userInterfaceStyle == .dark ? UIColor(hex6: 0xFFFFFF): UIColor(hex6: 0x469ad0)
    }
    static let circ = UIColor.init { trainCollection -> UIColor in
        return trainCollection.userInterfaceStyle == .dark ? UIColor(hex6: 0xFFFFFF): UIColor(hex6: 0xFFFFFF)
    }
    static let text = UIColor.init { trainCollection -> UIColor in
        return trainCollection.userInterfaceStyle == .dark ? UIColor(hex6: 0x000000): UIColor(hex6: 0xFFFFFF)
    }
    static let bgGray = UIColor.init { trainCollection -> UIColor in
        return trainCollection.userInterfaceStyle == .dark ? UIColor(hex6: 0x000000): UIColor(hex6: 0xf2f2f2)
    }
    static let bgWhite = UIColor.init { trainCollection -> UIColor in
        return trainCollection.userInterfaceStyle == .dark ? UIColor(hex6: 0x191919): UIColor(hex6: 0xFFFFFF)
    }
    static let bar = UIColor.init { trainCollection -> UIColor in
        return trainCollection.userInterfaceStyle == .dark ? UIColor(hex6: 0xFFFFFF): UIColor(hex6: 0x469ad0)
    }
}
