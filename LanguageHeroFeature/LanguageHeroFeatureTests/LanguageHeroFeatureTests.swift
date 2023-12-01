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
        XCTAssertEqual(sut.currentTalk, nil)
    }
    
    func test_score() {
        let input = "some input"
        let talk = Talk(value: input)
        let sut = makeSUT(talks: [talk])
        
        sut.execute(input: input)
        
        XCTAssertEqual(sut.score, 40.0)
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
        
        let sut = makeSUT(talks: [talk1, talk2], hero: Hero(attack: 15), monster: Monster(hp: 60))
        
        sut.execute(input: input1) // 15 * 2
        sut.execute(input: input2) // 15 * 4
        sut.execute(input: input2) // 15 * 8
        
        XCTAssertEqual(sut.currentTalk, talk2)
        XCTAssertEqual(sut.isOver, false)
        XCTAssertEqual(sut.score, 30 + 60 + 120)
    }
    
    func test_gameover() {
        let input1 = "input1"
        let input2 = "input2"
        let talk1 = Talk(value: input1)
        let talk2 = Talk(value: input2)
        
        let sut = makeSUT(talks: [talk1, talk2], hero: Hero(attack: 15), monster: Monster(hp: 30))
        
        sut.execute(input: input1)
        
        XCTAssertEqual(sut.isOver, false)
        
        sut.execute(input: input2)
        
        XCTAssertEqual(sut.isOver, true)
    }
    
    func test_restart() {
        let input1 = "input1"
        let input2 = "input2"
        let talk1 = Talk(value: input1)
        let talk2 = Talk(value: input2)
        let monster = Monster(hp: 30)
        let sut = makeSUT(talks: [talk1, talk2], hero: Hero(attack: 30), monster: monster)
        
        sut.execute(input: input1)
        
        XCTAssertEqual(sut.isOver, true)
        XCTAssertEqual(sut.attackingMonster.hp, 0)
        XCTAssertEqual(sut.currentTalk?.value, talk2.value)
        
        sut.restart()
        
        XCTAssertEqual(sut.isOver, false)
        XCTAssertEqual(sut.attackingMonster.hp, monster.hp)
        XCTAssertEqual(sut.score, 0)
        XCTAssertEqual(sut.currentTalk?.value, talk1.value)
    }
    
    // MARK: - Helper
    private func makeSUT(
        talks: [Talk],
        hero: Hero = Hero(),
        monster: Monster = Monster()
    ) -> GameProcessor {
        return GameProcessor(talks: talks, hero: hero, monster: monster)
    }
}
