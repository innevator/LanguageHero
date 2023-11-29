//
//  GameProcessor.swift
//  LanguageHeroFeature
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import Foundation

class GameProcessor {
    private(set) var score: UInt = 0
    private(set) var talks: [Talk] = []
    private var currentTalkIndex: Int = 0
    private(set) var isOver: Bool = false
    
    var currentTalk: Talk? {
        if talks.count == 0 { return nil }
        return talks.count > currentTalkIndex ? talks[currentTalkIndex] : talks[currentTalkIndex - 1]
    }
    
    init(talks: [Talk]) {
        self.talks = talks
    }
    
    func execute(input: String) {
        if input == currentTalk?.value {
            score += 1
            goNextTalk()
        }
    }
    
    private func goNextTalk() {
        if talks.count > currentTalkIndex {
            currentTalkIndex += 1
        }
        
        if talks.count == currentTalkIndex {
            isOver = true
        }
    }
}
