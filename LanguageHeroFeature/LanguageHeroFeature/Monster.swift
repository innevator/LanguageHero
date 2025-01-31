//
//  Monster.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/12/1.
//

import Foundation

public class Monster: Equatable {
    public private(set) var id: UUID = UUID()
    public private(set) var hp: Int
    public let maxHp: Int
    public private(set) var attack: Int
    private(set) var countDownAttackSeconds: TimeInterval
    
    public init(hp: Int = 100, attack: Int = 20, countDownAttackSeconds: TimeInterval = 5) {
        self.hp = hp
        self.maxHp = hp
        self.attack = attack
        self.countDownAttackSeconds = countDownAttackSeconds
    }
    
    public func beAttacked(damage: Int, isKilled: () -> ()) {
        self.hp -= damage
        if hp <= 0 { isKilled() }
    }
    
    public func attack(_ hero: Hero, killed: () -> ()) {
        hero.beAttacked(monster: self, isKilled: killed)
    }
    
    public func reset() {
        hp = self.maxHp
    }
    
    public static func == (lhs: Monster, rhs: Monster) -> Bool {
        return lhs.id == rhs.id
    }
}
