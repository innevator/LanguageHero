//
//  GameProcessor.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import Foundation

public class GameProcessor: ObservableObject {
    public enum GameStatus {
        case win, lose, playing, pause
    }
    
    @Published public private(set) var score: Int = 0
    @Published public private(set) var gameStatus: GameStatus = .playing {
        didSet {
            switch gameStatus {
            case .win, .lose, .pause:
                stop()
            case .playing:
                start()
            }
        }
    }
    
    private let damageCalculator: DamageRateCalculator = DamageRateCalculator()
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
    public private(set) var monsterAttackCountDownTimerPauseFireInterval: TimeInterval?
    
    public init(talks: [Talk], hero: Hero, monsters: [Monster]) {
        self.talks = talks
        self.hero = hero
        self.monsters = monsters
    }
    
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
    
    public func start() {
        startMonsterAttackCountDown()
    }
    
    private func startMonsterAttackCountDown() {
        let timer = Timer(fire: Date(timeIntervalSinceNow: monsterAttackCountDownTimerPauseFireInterval ?? currentMonster.countDownAttackSecond), interval: currentMonster.countDownAttackSecond, repeats: true) {[weak self] _ in
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
