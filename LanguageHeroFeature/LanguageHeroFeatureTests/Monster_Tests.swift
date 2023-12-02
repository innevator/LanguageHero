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
        
        XCTAssertEqual(sut.hp, 100)
    }
    
    func test_MonsterAttackHero_stillAlive() {
        let sut = Monster()
        let hero = Hero()
        
        sut.attack(hero) { }
        
        XCTAssertEqual(hero.hp, hero.maxHp - sut.attack)
    }
}
