//
//  ContentView.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

/// The main container view for the menu bar popover.
///
/// Manages navigation between the Dashboard, TimeSettings, and Preferences
/// screens using a state-driven approach (no NavigationStack, since this
/// lives inside a MenuBarExtra popover).
struct ContentView: View {
    @State private var currentDestination: NavigationDestination = .dashboard

    var body: some View {
        Group {
            switch currentDestination {
            case .dashboard:
                DashboardView(navigate: navigate)
            case .timeSettings:
                TimeSettingsView(navigate: navigate)
            case .preferences:
                PreferencesView(navigate: navigate)
            }
        }
        .frame(width: 320)
        .background(AppColors.background)
    }

    // MARK: - Navigation

    private func navigate(to destination: NavigationDestination) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentDestination = destination
        }
    }
}

#Preview {
    ContentView()
}
