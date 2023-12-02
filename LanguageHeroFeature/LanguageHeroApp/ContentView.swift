//
//  ContentView.swift
//  LanguageHeroApp
//
//  Created by 洪宗鴻 on 2023/11/29.
//

import SwiftUI
import LanguageHeroFeature

let talks: [String] = ["fireball", "thunder"]
let defaultTalks: [Talk] = talks.map { Talk(value: $0) }

struct ContentView: View {
    @StateObject var gameProcessor = GameProcessor(talks: defaultTalks, hero: Hero(), monster: Monster())
    @State var currentSeconds: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("時間: \(currentSeconds)")
            Text("分數: \(gameProcessor.score)")
            
            if gameProcessor.isOver {
                Spacer()
                
                restartView
            }
            else {
                monsterView
                
                Spacer()
                
                talkView
                
                Spacer()
                
                heroView
            }
            
            Spacer()
        }
        .padding()
        .onReceive(timer) { _ in
            if !gameProcessor.isOver {
                currentSeconds += 1
            }
        }
    }
    
    var monsterView: some View {
        VStack {
            ProgressView(value: Double(gameProcessor.monster.hp), total: Double(gameProcessor.monster.maxHp)).tint(Color.red)
            
            Rectangle().fill(Color.black).frame(width: 100, height: 100)
            
            Text("MonsterName")
        }
    }
    
    var restartView: some View {
        Button("restart") {
            gameProcessor.restart()
            currentSeconds = 0
        }
    }
    
    var talkView: some View {
        Text(gameProcessor.currentTalk?.value ?? "")
    }
    
    var heroView: some View {
        VStack {
            Rectangle().fill(Color.black).frame(width: 100, height: 100)
            
            Text("HeroName")
            ProgressView(value: Double(gameProcessor.hero.hp), total: Double(gameProcessor.hero.maxHp)).tint(Color.red)
            
            HStack {
                Button("action1") {
                    gameProcessor.execute(input: defaultTalks[0].value)
                }
                Button("action2") {
                    gameProcessor.execute(input: defaultTalks[1].value)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
