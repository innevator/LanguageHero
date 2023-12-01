//
//  Hero.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/12/1.
//

import Foundation

public struct Hero {
    public var hp: Int
    public var mp: Int
    public var attack: Int
    public var magicAttack: Int
    public var experience: Double
    
    public init(hp: Int = 100,
                mp: Int = 50,
                attack: Int = 20,
                magicAttack: Int = 20,
                experience: Double = 0) {
        self.hp = hp
        self.mp = mp
        self.attack = attack
        self.magicAttack = magicAttack
        self.experience = experience
    }
}
