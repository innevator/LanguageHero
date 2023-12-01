//
//  GameProcessor.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import Foundation

public class GameProcessor: ObservableObject {
    @Published public private(set) var score: Double = 0
    public private(set) var talks: [Talk] = []
    private var currentTalkIndex: Int = 0
    public private(set) var isOver: Bool = false
    private let damageCalculator: DamageCalculator = DamageCalculator()
    private let hero: Hero
    private var monster: Monster
    
    public var currentTalk: Talk? {
        if talks.count == 0 { return nil }
        return talks.count > currentTalkIndex ? talks[currentTalkIndex] : talks[currentTalkIndex - 1]
    }
    
    public init(talks: [Talk], hero: Hero, monster: Monster) {
        self.talks = talks
        self.hero = hero
        self.monster = monster
    }
    
    public func execute(input: String) {
        if !isOver, let currentTalk = self.currentTalk {
            let damageRate = damageCalculator.calculate(input: input, talk: currentTalk)
            let damage = damageRate * Double(hero.attack)
            self.monster = hero.attack(monster)
            score += damage
            goNextTalk()
        }
    }
    
    private func goNextTalk() {
        if talks.count > currentTalkIndex {
            currentTalkIndex += 1
        }
        
        if monster.hp <= 0 {
            isOver = true
        }
    }
}
