//
//  WorkTimeIsItApp.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

@main
struct WorkTimeIsItApp: App {
    @State private var timeManager = TimeManager()
    @State private var settingsManager = UserDefaultsManager.shared
    @State private var spriteRenderer = StatusItemSpriteRenderer()

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environment(timeManager)
                .environment(settingsManager)
        } label: {
            MenuBarLabel(timeManager: timeManager, spriteRenderer: spriteRenderer, settingsManager: settingsManager)
        }
        .menuBarExtraStyle(.window)
    }
}

