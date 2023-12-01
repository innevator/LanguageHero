//
//  DamageCalculator.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/12/1.
//

import Foundation

public class DamageCalculator {
    public private(set) var rate: Double
    public private(set) var totalDamage: Double
    
    public init(rate: Double = 1, totalDamage: Double = 0) {
        self.rate = rate
        self.totalDamage = totalDamage
    }
    
    public func calculate(input: String, talk: Talk) -> Double {
        if input == talk.value {
            self.rate = 2
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
                self.rate = self.rate * (self.rate + Double(correntInputs)/Double(talks.count))
            }
            else {
                self.rate = 0
            }
        }
        
        return self.rate
    }
}
