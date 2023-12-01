//
//  Monster.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/12/1.
//

import Foundation

public class Monster {
    public private(set) var hp: Int
    public let maxHp: Int
    public private(set) var attack: Int
    private(set) var countDownAttackSecond: TimeInterval
    
    public init(hp: Int = 100, attack: Int = 20, countDownAttackSecond: TimeInterval = 5) {
        self.hp = hp
        self.maxHp = hp
        self.attack = attack
        self.countDownAttackSecond = countDownAttackSecond
    }
    
    public func beAttacked(by hero: Hero) {
        self.hp -= hero.attack
    }
    
    public func attack(_ hero: Hero) {
        hero.beAttacked(by: self)
    }
    
    public func reset() {
        hp = self.maxHp
    }
}
