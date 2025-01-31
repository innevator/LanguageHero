//
//  DamageCalculator.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/12/1.
//

import Foundation

public class DamageRateCalculator {
    public static let initialRate: Double = 1
    
    public private(set) var rate: Double
    
    public init(rate: Double = DamageRateCalculator.initialRate) {
        self.rate = rate
    }
    
    public func calculate(input: String, talk: Talk) -> Double {
        if input == talk.value {
            self.rate *= 2
        }
        else {
            
            let inputs = input.components(separatedBy: " ")
            let talks = talk.value.components(separatedBy: " ")
            var calculateTalks = talks
            var correntInputs = 0
            for input in inputs {
                if let index = calculateTalks.firstIndex(of: input) {
                    calculateTalks.remove(at: index)
                    correntInputs += 1
                }
            }
            
            if correntInputs > 0 {
                self.rate *= self.rate * (self.rate + Double(correntInputs)/Double(talks.count))
            }
            else {
                self.rate = 1
            }
        }
        
        return self.rate
    }
    
    public func reset() {
        self.rate = DamageRateCalculator.initialRate
    }
}
