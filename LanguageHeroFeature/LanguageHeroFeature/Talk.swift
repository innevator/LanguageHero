//
//  Talk.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import Foundation

public struct Talk: Equatable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}
