//
//  LanguageHeroFeatureTests.swift
//  LanguageHeroFeatureTests
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import XCTest
import LanguageHeroFeature

final class LanguageHeroFeatureTests: XCTestCase {
    func test_initialize() {
        let sut = makeSUT(talks: [])
        
        XCTAssertEqual(sut.score, 0)
        XCTAssertEqual(sut.talks.count, 0)
        XCTAssertEqual(sut.currentTalk, Talk())
        XCTAssertEqual(sut.monsterAttackCountDownTimer, nil)
        XCTAssertEqual(sut.gameStatus, .playing)
    }
    
    func test_score() {
        let input = "some input"
        let talk = Talk(value: input)
        let sut = makeSUT(talks: [talk])
        
        sut.execute(input: input)
        
        XCTAssertEqual(sut.score > 0, true)
    }
    
    func test_changeToNextTalk() {
        let input1 = "input1"
        let input2 = "input2"
        let input3 = "input3"
        let talk1 = Talk(value: input1)
        let talk2 = Talk(value: input2)
        let talk3 = Talk(value: input3)
        
        let sut = makeSUT(talks: [talk1, talk2, talk3])
        
        sut.execute(input: input1)
        
        XCTAssertEqual(sut.currentTalk, talk2)
        
        sut.execute(input: input2)
        
        XCTAssertEqual(sut.currentTalk, talk3)
    }
    
    func test_processNoEnoughTalksWontGameOverOrCrash_stillCanScore() {
        let input1 = "input1"
        let input2 = "input2"
        let talk1 = Talk(value: input1)
        let talk2 = Talk(value: input2)
        let heroAttack = 15
        let sut = makeSUT(talks: [talk1, talk2], hero: Hero(attack: heroAttack), monsters: [Monster(hp: 2000)])
        
        sut.execute(input: input1) // 15 * 2
        sut.execute(input: input2) // 15 * 4
        sut.execute(input: input2) // 15 * 8
        
        XCTAssertEqual(sut.currentTalk, talk2)
        XCTAssertEqual(sut.gameStatus, .playing)
        XCTAssertEqual(sut.score, heroAttack * 14)
    }
    
    func test_winGame() {
        let input1 = "input1"
        let input2 = "input2"
        let talk1 = Talk(value: input1)
        let talk2 = Talk(value: input2)
        let attack = 15
        let sut = makeSUT(talks: [talk1, talk2], hero: Hero(attack: attack), monsters: [Monster(hp: attack * 6)])
        
        sut.execute(input: input1) // 15 * 2
        
        XCTAssertEqual(sut.gameStatus, .playing)
        
        sut.execute(input: input2) // 15 * 4
        
        XCTAssertEqual(sut.gameStatus, .win)
        XCTAssertEqual(sut.monsterAttackCountDownTimer, nil)
    }
    
    func test_winGameAndRestartPlay() {
        let input1 = "input1"
        let input2 = "input2"
        let talk1 = Talk(value: input1)
        let talk2 = Talk(value: input2)
        let heroAttack = 30
        let sut = makeSUT(talks: [talk1, talk2], hero: Hero(attack: heroAttack), monsters:  [Monster(hp: heroAttack * 2)])
        
        sut.execute(input: input1) // 30 * 2
        
        XCTAssertEqual(sut.gameStatus, .win)
        XCTAssertEqual(sut.currentMonster.hp, 0)
        XCTAssertEqual(sut.currentTalk.value, talk2.value)
        
        sut.restart()
        
        XCTAssertEqual(sut.gameStatus, .playing)
        XCTAssertEqual(sut.currentMonster.hp, sut.currentMonster.maxHp)
        XCTAssertEqual(sut.score, 0)
        XCTAssertEqual(sut.currentTalk.value, talk1.value)
        
        sut.execute(input: input1) // 30 * 2
        
        XCTAssertEqual(sut.score, heroAttack * 2)
    }
    
    func test_MonsterAttackCountDown() {
        let input1 = "input1"
        let input2 = "input2"
        let talk1 = Talk(value: input1)
        let talk2 = Talk(value: input2)
        let hero = Hero(hp: 100)
        let countDownAttackSecond: TimeInterval = 0.02
        let monster = Monster(hp: 30, attack: 20, countDownAttackSecond: countDownAttackSecond)
        let sut = makeSUT(talks: [talk1, talk2], hero: hero, monsters: [monster])
        
        sut.start()
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: countDownAttackSecond * 1.3))
        
        XCTAssertEqual(sut.hero.hp, sut.hero.maxHp - monster.attack)
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: countDownAttackSecond * 1.3))
        
        XCTAssertEqual(sut.hero.hp, sut.hero.maxHp - monster.attack * 2)
    }
    
    func test_loseGameAndRestartPlay() {
        let hp = 20
        let hero = Hero(hp: hp)
        let countDownAttackSecond: TimeInterval = 0.02
        let monster = Monster(attack: hp, countDownAttackSecond: countDownAttackSecond)
        let sut = makeSUT(talks: [], hero: hero, monsters: [monster])
        
        sut.start()
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: countDownAttackSecond * 1.3))
        
        XCTAssertEqual(sut.gameStatus, .lose)
        
        sut.restart()
        
        XCTAssertEqual(sut.gameStatus, .playing)
        XCTAssertEqual(sut.hero.hp, sut.hero.maxHp)
    }
    
    func test_winGameWhenKillAllMonsters() {
        let damage = 20
        let hero = Hero(attack: damage)
        let monsters = getMonsters(count: 3, hp: damage)
        let sut = makeSUT(talks: [Talk()], hero: hero, monsters: monsters)
        
        XCTAssertEqual(sut.currentMonster, monsters[0])
        
        sut.execute(input: "")
        
        XCTAssertEqual(sut.gameStatus, .playing)
        XCTAssertEqual(sut.currentMonster, monsters[1])
        
        sut.execute(input: "")
        
        XCTAssertEqual(sut.gameStatus, .playing)
        XCTAssertEqual(sut.currentMonster, monsters[2])
        
        sut.execute(input: "")
        
        XCTAssertEqual(sut.gameStatus, .win)
    }
    
    func test_winGameAndRestartShouldResetToFirstOneMonster() {
        let damage = 20
        let hero = Hero(attack: damage)
        let monsters = getMonsters(count: 2, hp: damage)
        let sut = makeSUT(talks: [Talk()], hero: hero, monsters: monsters)
        
        sut.execute(input: "")
        sut.execute(input: "")
        sut.restart()
        
        XCTAssertEqual(sut.currentMonster, monsters[0])
    }
    
    func test_gamePauseAndResume() {
        let damage = 20
        let hero = Hero(hp: damage)
        let countdown = 0.02
        let monster = Monster(attack: damage, countDownAttackSecond: countdown)
        let sut = makeSUT(talks: [Talk()], hero: hero, monsters: [monster])
        
        sut.start()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: countdown / 2))
        sut.pause()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: countdown))
        
        XCTAssertEqual(sut.gameStatus, .pause)
        XCTAssertEqual(sut.hero.hp, sut.hero.maxHp)
        
        sut.resume()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: countdown / 2))
        
        XCTAssertEqual(sut.gameStatus, .lose)
        XCTAssertEqual(sut.hero.hp, 0)
    }
    
    // MARK: - Helper
    private func makeSUT(
        talks: [Talk],
        hero: Hero = Hero(),
        monsters: [Monster] = [Monster()]
    ) -> GameProcessor {
        return GameProcessor(talks: talks, hero: hero, monsters: monsters)
    }
    
    private func getMonsters(count: UInt, hp: Int = 20) -> [Monster] {
        var monsters: [Monster] = []
        for _ in 0..<count { monsters.append(Monster(hp: hp)) }
        return monsters
    }
}
