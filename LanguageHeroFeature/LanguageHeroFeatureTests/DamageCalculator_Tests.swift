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
        
        let rate = sut.calculate(input: input, talk: talk)
        
        XCTAssertEqual(rate, 2)
    }
    
    func test_keepIncreaseDamageRate() {
        let sut = DamageCalculator()
        let input = ""
        let talk = Talk(value: "")
        
        let _ = sut.calculate(input: input, talk: talk)
        let rate2 = sut.calculate(input: input, talk: talk)
        
        XCTAssertEqual(rate2, 4)
    }
    
    func test_decreaseDamageRateToMinWithNoneCorrectInput() {
        let sut = DamageCalculator()
        let input = ""
        let talk = Talk(value: "talk")
        
        let rate = sut.calculate(input: input, talk: talk)
        
        XCTAssertEqual(rate, 1)
    }
    
    func test_increaseDamageRateWithSomeCorrectInput() {
        let sut = DamageCalculator()
        let input = "this a"
        let talk = Talk(value: "this is a talk")
        
        let rate = sut.calculate(input: input, talk: talk)
        
        XCTAssertEqual(rate, 1.5)
    }
}
