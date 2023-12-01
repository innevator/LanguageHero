//
//  Monster.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/12/1.
//

import Foundation

public struct Monster {
    public private(set) var hp: Int
    
    public init(hp: Int = 100) {
        self.hp = hp
    }
    
    public mutating func beAttacked(by hero: Hero) {
        self.hp -= hero.attack
    }
}
