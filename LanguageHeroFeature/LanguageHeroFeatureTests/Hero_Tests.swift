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
        
        XCTAssertEqual(sut.hp, 100)
        XCTAssertEqual(sut.mp, 50)
        XCTAssertEqual(sut.attack, 20)
        XCTAssertEqual(sut.magicAttack, 20)
        XCTAssertEqual(sut.experience, 0)
    }
}
