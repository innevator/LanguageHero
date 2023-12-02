//
//  GameProcessor.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import Foundation

public class GameProcessor: ObservableObject {
    @Published public private(set) var score: Double = 0
    @Published public private(set) var isOver: Bool = false {
        didSet {
            if isOver {
                if monsterAttackCountDownTimer?.isValid == true {
                    monsterAttackCountDownTimer?.invalidate()
                    monsterAttackCountDownTimer = nil
                }
            }
            else {
                startMonsterAttackCountDown()
            }
        }
    }
    public let talks: [Talk]
    private var currentTalkIndex: Int = 0
    private let damageCalculator: DamageCalculator = DamageCalculator()
    public let hero: Hero
    public let monster: Monster
    public private(set) var monsterAttackCountDownTimer: Timer?
    
    public var currentTalk: Talk? {
        if talks.count == 0 { return nil }
        return talks.count > currentTalkIndex ? talks[currentTalkIndex] : talks[currentTalkIndex - 1]
    }
    
    public init(talks: [Talk], hero: Hero, monster: Monster) {
        self.talks = talks
        self.hero = hero
        self.monster = monster
        
        startMonsterAttackCountDown()
    }
    
    public func execute(input: String) {
        if !isOver, let currentTalk = self.currentTalk {
            let damageRate = damageCalculator.calculate(input: input, talk: currentTalk)
            let damage = damageRate * Double(hero.attack)
            hero.attack(monster)
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
        
        if hero.hp <= 0 {
            isOver = true
        }
    }
    
    public func restart() {
        isOver = false
        monster.reset()
        hero.reset()
        score = 0
        currentTalkIndex = 0
        damageCalculator.reset()
    }
    
    public func startMonsterAttackCountDown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + monster.countDownAttackSecond) {
            self.monsterAttackCountDownTimer = Timer.scheduledTimer(withTimeInterval: self.monster.countDownAttackSecond, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.monster.attack(self.hero)
                
                if self.hero.hp <= 0 {
                    self.isOver = true
                }
            }
            self.monsterAttackCountDownTimer?.fire()
        }
    }
}
