//
//  GameProcessor.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import Foundation

/// Tthe main game flow
public final class GameProcessor {
    public enum GameStatus {
        case win, lose, playing, pause
    }
    
    // MARK: - Properties
    
    private let damageCalculator: DamageRateCalculator = DamageRateCalculator()
    
    // MARK: - GameState
    
    public private(set) var score: Int = 0
    public private(set) var gameStatus: GameStatus = .playing {
        didSet {
            switch gameStatus {
            case .win, .lose, .pause:
                stop()
            case .playing:
                start()
            }
        }
    }
    
    
    // MARK: - Hero
    
    public let hero: Hero
    
    // MARK: - Talks
    
    public let talks: [Talk]
    private var currentTalkIndex: Int = 0
    public var currentTalk: Talk {
        if talks.count == 0 { return Talk() }
        return talks.count > currentTalkIndex ? talks[currentTalkIndex] : talks[currentTalkIndex - 1]
    }
    
    // MARK: - Monsters
    
    public let monsters: [Monster]
    private var currentMonsterIndex: Int = 0
    public var currentMonster: Monster {
        if monsters.count == 0 { return Monster() }
        return monsters.count > currentMonsterIndex ? monsters[currentMonsterIndex] : monsters[currentMonsterIndex - 1]
    }
    public private(set) var monsterAttackCountDownTimer: Timer?
    private var monsterAttackCountDownTimerPauseFireInterval: TimeInterval?
    
    
    // MARK: - Initiailizer
    
    public init(talks: [Talk], hero: Hero, monsters: [Monster]) {
        self.talks = talks
        self.hero = hero
        self.monsters = monsters
    }
    
    
    // MARK: - Functions
    
    public func execute(input: String) {
        if gameStatus == .playing {
            let damageRate = damageCalculator.calculate(input: input, talk: currentTalk)
            let damage = Int(damageRate * Double(hero.attack))
            hero.attack(currentMonster, damage: damage) { [weak self] in
                guard let hp = self?.monsters.last?.hp else { return }
                if hp <= 0 {
                    self?.gameStatus = .win
                }
                else {
                    self?.currentMonsterIndex += 1
                }
            }
            score += damage
            goNextTalk()
        }
    }
    
    private func goNextTalk() {
        if talks.count > currentTalkIndex {
            currentTalkIndex += 1
        }
    }
    
    public func restart() {
        gameStatus = .playing
        monsters.forEach({ $0.reset() })
        hero.reset()
        score = 0
        currentTalkIndex = 0
        currentMonsterIndex = 0
        damageCalculator.reset()
    }
}


// MARK: - GameFlow

extension GameProcessor {
    public func start() {
        startMonsterAttackCountDown()
    }
    
    private func stop() {
        stopMonsterAttackCountDown()
    }
    
    public func pause() {
        monsterAttackCountDownTimerPauseFireInterval = monsterAttackCountDownTimer?.fireDate.timeIntervalSinceNow
        gameStatus = .pause
    }
    
    public func resume() {
        gameStatus = .playing
        monsterAttackCountDownTimerPauseFireInterval = nil
    }
}


// MARK: - MonsterTimer

extension GameProcessor {
    private func startMonsterAttackCountDown() {
        let timer = Timer(fire: Date(timeIntervalSinceNow: monsterAttackCountDownTimerPauseFireInterval ?? currentMonster.countDownAttackSeconds), interval: currentMonster.countDownAttackSeconds, repeats: true) {[weak self] _ in
            guard let self = self else { return }
            self.currentMonster.attack(self.hero) { [weak self] in
                self?.gameStatus = .lose
            }
        }
        self.monsterAttackCountDownTimer = timer
        RunLoop.current.add(timer, forMode: .common)
    }
    
    private func stopMonsterAttackCountDown() {
        if monsterAttackCountDownTimer?.isValid == true {
            monsterAttackCountDownTimer?.invalidate()
            monsterAttackCountDownTimer = nil
        }
    }
}
