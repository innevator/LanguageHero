//
//  DamageCalculator_Tests.swift
//  LanguageHeroFeatureTests
//
//  Created by 洪宗鴻 on 2023/12/1.
//

import XCTest
import LanguageHeroFeature

final class DamageCalculator_Tests: XCTestCase {
    func test_initialize() {
        let sut = DamageCalculator()
        
        XCTAssertEqual(sut.rate, 1)
        XCTAssertEqual(sut.totalDamage, 0)
    }
    
    func test_increaseDamageRateToMaxWithHighCorrectInput() {
        let sut = DamageCalculator()
        let input = ""
        let talk = Talk(value: "")
        
        sut.calculate(input: input, talk: talk)
        
        XCTAssertEqual(sut.rate, 2)
    }
    
    func test_decreaseDamageRateToMinWithNoneCorrectInput() {
        let sut = DamageCalculator()
        let input = ""
        let talk = Talk(value: "talk")
        
        sut.calculate(input: input, talk: talk)
        
        XCTAssertEqual(sut.rate, 0)
    }
    
    func test_decreaseDamageRateWithSomeCorrectInput() {
        let sut = DamageCalculator()
        let input = "this a"
        let talk = Talk(value: "this is a talk")
        
        sut.calculate(input: input, talk: talk)
        
        XCTAssertEqual(sut.rate, 1 + 1 * 0.5)
    }
}
