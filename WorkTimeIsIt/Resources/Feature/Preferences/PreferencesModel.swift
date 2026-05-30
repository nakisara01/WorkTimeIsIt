//
//  PreferencesModel.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

/// Data model representing the user's display and UI preferences.
struct PreferencesData {
    /// 메뉴바 표시 모드: remaining time vs end time
    var displayMode: DisplayMode

    /// Countdown display style (compact vs expanded)
    var countdownStyle: Bool

    /// Index of the selected sprite icon (0-3)
    var selectedSpriteIndex: Int

    /// Default preferences configuration.
    static var `default`: PreferencesData {
        PreferencesData(
            displayMode: .remainingTime,
            countdownStyle: false,
            selectedSpriteIndex: 0
        )
    }
}
