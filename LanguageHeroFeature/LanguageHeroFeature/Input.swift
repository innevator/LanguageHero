//
//  Input.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/12/7.
//

import Foundation

public protocol Input: Equatable {
    var value: String { get }
}

extension Input {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}
