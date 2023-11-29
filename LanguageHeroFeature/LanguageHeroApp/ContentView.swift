//
//  ContentView.swift
//  LanguageHeroApp
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import SwiftUI
import LanguageHeroFeature

let talks: [String] = ["talk1", "talk2"]
let defaultTalks: [Talk] = talks.map { Talk(value: $0) }

struct ContentView: View {
    @StateObject var gameProcessor = GameProcessor(talks: defaultTalks)
    
    var body: some View {
        VStack {
            Text("分數: \(gameProcessor.score)")
            
            Text(gameProcessor.currentTalk?.value ?? "")
            
            HStack {
                Button("action1") {
                    gameProcessor.execute(input: "talk1")
                }
                Button("action2") {
                    gameProcessor.execute(input: "talk2")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
