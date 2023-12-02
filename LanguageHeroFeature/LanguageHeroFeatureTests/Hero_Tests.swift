//
//  Hero_Tests.swift
//  LanguageHeroFeatureTests
//
//  Created by 洪宗鴻 on 2023/12/1.
//

import XCTest
import LanguageHeroFeature

final class Hero_Tests: XCTestCase {
    func test_initialize() {
        let sut = Hero()
        
        XCTAssertEqual(sut.hp, sut.maxHp)
        XCTAssertEqual(sut.experience, 0)
    }
    
    func test_HeroAttackMonster() {
        let damage = 20
        let sut = Hero(attack: damage)
        let monster = Monster(hp: damage * 2)
        var killedMonster = false
        
        sut.attack(monster, damage: damage) {
            killedMonster = true
        }
        
        XCTAssertEqual(monster.hp, monster.maxHp - sut.attack)
        XCTAssertEqual(killedMonster, false)
        
        sut.attack(monster, damage: damage) {
            killedMonster = true
        }
        
        XCTAssertEqual(monster.hp, 0)
        XCTAssertEqual(killedMonster, true)
    }
    
    func test_HeroBeAttackedByMonster() {
        let damage = 20
        let sut = Hero(hp: damage * 2)
        let monster = Monster(attack: damage)
        var killedMonster = false
        
        sut.beAttacked(monster: monster) {
            killedMonster = true
        }
        
        XCTAssertEqual(sut.hp, sut.maxHp - monster.attack)
        XCTAssertEqual(killedMonster, false)
        
        sut.beAttacked(monster: monster) {
            killedMonster = true
        }
        
        XCTAssertEqual(sut.hp, 0)
        XCTAssertEqual(killedMonster, true)
    }
    
    func test_HeroReset() {
        let monster = Monster()
        let sut = Hero(hp: monster.attack)
        
        sut.beAttacked(monster: monster) {}
        
        XCTAssertEqual(sut.hp, 0)
        
        sut.reset()
        
        XCTAssertEqual(sut.hp, sut.maxHp)
    }
}
