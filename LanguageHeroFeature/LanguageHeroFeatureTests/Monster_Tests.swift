//
//  Monster_Tests.swift
//  LanguageHeroFeatureTests
//
//  Created by 洪宗鴻 on 2023/12/2.
//

import XCTest
import LanguageHeroFeature

final class Monster_Tests: XCTestCase {
    func test_initialize() {
        let sut = Monster()
        
        XCTAssertEqual(sut.hp, sut.maxHp)
    }
    
    func test_MonsterAttackHero() {
        let attack = 20
        let sut = Monster(attack: attack)
        let hero = Hero(hp: attack * 2)
        var killedHero = false
        
        sut.attack(hero) { killedHero = true }
        
        XCTAssertEqual(hero.hp, hero.maxHp - sut.attack)
        XCTAssertEqual(killedHero, false)
        
        sut.attack(hero) { killedHero = true }
        
        XCTAssertEqual(hero.hp, 0)
        XCTAssertEqual(killedHero, true)
    }
    
    func test_MonsterBeAttackedByHero() {
        let attack = 20
        let sut = Monster(hp: attack * 2)
        let hero = Hero(attack: attack)
        var isKilled = false
        
        sut.beAttacked(damage: attack) { isKilled = true }
        
        XCTAssertEqual(sut.hp, sut.maxHp - hero.attack)
        XCTAssertEqual(isKilled, false)
        
        sut.beAttacked(damage: attack) { isKilled = true }
        
        XCTAssertEqual(sut.hp, 0)
        XCTAssertEqual(isKilled, true)
    }
    
    func test_MonsterReset() {
        let sut = Monster()
        
        sut.beAttacked(damage: sut.maxHp) {}
        
        XCTAssertEqual(sut.hp, 0)
        
        sut.reset()
        
        XCTAssertEqual(sut.hp, sut.maxHp)
    }
}
