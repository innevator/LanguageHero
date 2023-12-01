//
//  GameProcessor.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import Foundation

public class GameProcessor: ObservableObject {
    @Published public private(set) var score: Double = 0
    @Published public private(set) var isOver: Bool = false
    public let talks: [Talk]
    private var currentTalkIndex: Int = 0
    private let damageCalculator: DamageCalculator = DamageCalculator()
    private let hero: Hero
    private let monster: Monster
    public private(set) var attackingMonster: Monster
    
    public var currentTalk: Talk? {
        if talks.count == 0 { return nil }
        return talks.count > currentTalkIndex ? talks[currentTalkIndex] : talks[currentTalkIndex - 1]
    }
    
    public init(talks: [Talk], hero: Hero, monster: Monster) {
        self.talks = talks
        self.hero = hero
        self.monster = monster
        self.attackingMonster = monster
    }
    
    public func execute(input: String) {
        if !isOver, let currentTalk = self.currentTalk {
            let damageRate = damageCalculator.calculate(input: input, talk: currentTalk)
            let damage = damageRate * Double(hero.attack)
            self.attackingMonster = hero.attack(attackingMonster)
            score += damage
            goNextTalk()
        }
    }
    
    private func goNextTalk() {
        if talks.count > currentTalkIndex {
            currentTalkIndex += 1
        }
        
        if attackingMonster.hp <= 0 {
            isOver = true
        }
    }
    
    public func restart() {
        isOver = false
        attackingMonster = monster
        score = 0
    }
}
