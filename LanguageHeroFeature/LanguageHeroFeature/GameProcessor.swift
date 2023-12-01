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
    
    public var currentTalk: Talk? {
        if talks.count == 0 { return nil }
        return talks.count > currentTalkIndex ? talks[currentTalkIndex] : talks[currentTalkIndex - 1]
    }
    
    public init(talks: [Talk], hero: Hero) {
        self.talks = talks
        self.hero = hero
    }
    
    public func execute(input: String) {
        if !isOver, let currentTalk = self.currentTalk {
            let damageRate = damageCalculator.calculate(input: input, talk: currentTalk)
            score += damageRate * Double(hero.attack)
            goNextTalk()
        }
    }
    
    private func goNextTalk() {
        if talks.count > currentTalkIndex {
            currentTalkIndex += 1
        }
        
        if talks.count == currentTalkIndex {
            isOver = true
        }
    }
}
