//
//  Settings.swift
//  HelloGame
//
//  Created by 崔泰毓 on 24/08/2019.
//  Copyright © 2019 崔泰毓. All rights reserved.
//

import SpriteKit

enum PhysicsCatageories {
    static let none: UInt32 = 0
    static let ballCategory: UInt32 = 0x1 //01
    static let switchCategory: UInt32 = 0x1 << 1//10
}

enum ZPositions {
    static let label: CGFloat = 0
    static let eater: CGFloat = 1
    static let colorSwiitch: CGFloat = 2
}
