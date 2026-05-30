//
//  PreferencesViewModel.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

/// ViewModel managing preferences state and persistence.
/// Uses @Observable macro for modern SwiftUI state management.
@Observable
final class PreferencesViewModel {
    // MARK: - Preferences State

    /// 메뉴바 표시 모드 (남은 시간 vs 퇴근 시간)
    var displayMode: DisplayMode {
        didSet { autoSave() }
    }

    /// Countdown 표시 스타일 (상세 표시 여부)
    var countdownStyle: Bool {
        didSet { autoSave() }
    }

    /// 선택된 스프라이트 아이콘 인덱스 (0-3)
    var selectedSpriteIndex: Int {
        didSet { autoSave() }
    }

    // MARK: - Navigation

    /// Callback to navigate to a different screen.
    var navigate: ((NavigationDestination) -> Void)?

    // MARK: - Sprite Configuration

    /// Available sprite options for the menu bar.
    /// Index order matches StatusItemSpriteRenderer's sprite list.
    let spriteOptions: [(name: String, index: Int)] = [
        ("광부", 0),
        ("러너", 1),
        ("로켓", 2),
        ("서퍼", 3)
    ]

    // MARK: - Initialization

    init(navigate: ((NavigationDestination) -> Void)? = nil) {
        let defaults = PreferencesData.default
        self.displayMode = defaults.displayMode
        self.countdownStyle = defaults.countdownStyle
        self.selectedSpriteIndex = defaults.selectedSpriteIndex
        self.navigate = navigate

        load()
    }

    // MARK: - Computed Properties

    /// Whether the display mode shows remaining time.
    var showsRemainingTime: Bool {
        get { displayMode == .remainingTime }
        set { displayMode = newValue ? .remainingTime : .endTime }
    }

    // MARK: - Persistence

    /// Loads saved preferences from UserDefaultsManager.
    @MainActor
    func load() {
        let manager = UserDefaultsManager.shared
        displayMode = manager.displayMode
        selectedSpriteIndex = manager.selectedSpriteIndex
        // Note: countdownStyle uses local state; UserDefaultsManager may not have
        // this property yet. Falls back to default if unavailable.
    }

    /// Saves the current preferences to UserDefaultsManager immediately.
    @MainActor
    private func autoSave() {
        let manager = UserDefaultsManager.shared
        manager.displayMode = displayMode
        manager.selectedSpriteIndex = selectedSpriteIndex
        // Note: countdownStyle will be persisted once UserDefaultsManager adds support.
    }

    /// Selects a sprite at the given index.
    func selectSprite(at index: Int) {
        guard index >= 0 && index < spriteOptions.count else { return }
        selectedSpriteIndex = index
    }

    /// Navigates back to the dashboard.
    func goBack() {
        navigate?(.dashboard)
    }
}
