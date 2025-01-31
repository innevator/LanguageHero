//
//  Hero.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/12/1.
//

import Foundation

public class Hero {
    public private(set) var hp: Int
    public let maxHp: Int
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
        self.maxHp = hp
        self.mp = mp
        self.attack = attack
        self.magicAttack = magicAttack
        self.experience = experience
    }
    
    public func attack(_ monster: Monster, damage: Int, killed: () -> ()) {
        monster.beAttacked(damage: damage, isKilled: killed)
    }
    
    public func beAttacked(monster: Monster, isKilled: () -> ()) {
        self.hp -= monster.attack
        if hp <= 0 { isKilled() }
    }
    
    public func reset() {
        self.hp = maxHp
    }
}
