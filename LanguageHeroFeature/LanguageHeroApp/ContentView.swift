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
    @Environment (\.scenePhase) private var scenePhase
    private let gameProcessor = GameProcessor(talks: defaultTalks, hero: Hero(), monsters: [Monster(), Monster()])
    @State var currentSeconds: Int = 0
    @State var updateRate: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let fpsTimer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            if gameProcessor.gameStatus == .pause {
                pauseView.zIndex(2)
            }
            
            VStack {
                Text("\(updateRate)").hidden()
                Text("時間: \(currentSeconds)")
                Text("分數: \(gameProcessor.score)")
                
                if gameProcessor.gameStatus == .win || gameProcessor.gameStatus == .lose {
                    Spacer()
                    
                    resultView
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
            .zIndex(1)
        }
        .onAppear {
            gameProcessor.start()
        }
        .onReceive(timer) { _ in
            if gameProcessor.gameStatus == .playing {
                currentSeconds += 1
            }
        }
        .onReceive(fpsTimer) { _ in
            updateRate += 1
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .inactive {
                gameProcessor.pause()
            }
        }
    }
    
    var monsterView: some View {
        VStack {
            ProgressView(value: Double(gameProcessor.currentMonster.hp), total: Double(gameProcessor.currentMonster.maxHp)).tint(Color.red)
            
            Rectangle().fill(Color.black).frame(width: 100, height: 100)
            
            Text("MonsterName")
        }
    }
    
    var resultView: some View {
        VStack {
            Text(gameProcessor.gameStatus == .win ? "Win!!!" : "Lose...")
                .font(.largeTitle)
            
            Button("restart") {
                gameProcessor.restart()
                currentSeconds = 0
            }
        }
    }
    
    var talkView: some View {
        Text(gameProcessor.currentTalk.value)
    }
    
    var heroView: some View {
        VStack {
            Rectangle().fill(Color.black).frame(width: 100, height: 100)
            
            Text("HeroName")
            ProgressView(value: Double(gameProcessor.hero.hp), total: Double(gameProcessor.hero.maxHp)).tint(Color.red)
            
            HStack {
                Button("action1") {
                    gameProcessor.execute(input: defaultTalks[0])
                }
                Button("action2") {
                    gameProcessor.execute(input: defaultTalks[1])
                }
            }
        }
    }
    
    var pauseView: some View {
        ZStack {
            Button("resume") {
                gameProcessor.resume()
            }
            .zIndex(2)
            Color(UIColor(white: 0, alpha: 0.8))
                .ignoresSafeArea()
                .zIndex(1)
        }
    }
}

#Preview {
    ContentView()
}
