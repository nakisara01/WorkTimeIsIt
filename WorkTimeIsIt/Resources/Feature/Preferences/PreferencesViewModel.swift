//
//  PreferencesViewModel.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

/// ViewModel managing preferences state and persistence.
/// Uses @Observable macro for modern SwiftUI state management.
///
/// NOTE: `@Observable`이 `didSet` 옵저버를 안정적으로 보존하지 못할 수 있으므로,
/// 프로퍼티 변경 시 명시적으로 UserDefaultsManager에 저장합니다.
@MainActor
@Observable
final class PreferencesViewModel {
    // MARK: - Preferences State

    /// 메뉴바 표시 모드 (남은 시간 vs 퇴근 시간)
    var displayMode: DisplayMode

    /// 선택된 스프라이트 아이콘 인덱스 (0-3)
    var selectedSpriteIndex: Int

    // MARK: - Navigation

    /// Callback to navigate to a different screen.
    var navigate: ((NavigationDestination) -> Void)?

    // MARK: - Sprite Configuration

    /// Available sprite options for the menu bar.
    /// Index order matches StatusItemSpriteRenderer's sprite list.
    var spriteOptions: [(name: String, index: Int)] {
        [
            (String(localized: "sprite.miner"), 0),
            (String(localized: "sprite.runner"), 1),
            (String(localized: "sprite.rocket"), 2),
            (String(localized: "sprite.surfer"), 3)
        ]
    }

    // MARK: - Initialization

    init(navigate: ((NavigationDestination) -> Void)? = nil) {
        let manager = UserDefaultsManager.shared
        self.displayMode = manager.displayMode
        self.selectedSpriteIndex = manager.selectedSpriteIndex
        self.navigate = navigate
    }

    // MARK: - Computed Properties

    /// Whether the display mode shows remaining time.
    var showsRemainingTime: Bool {
        get { displayMode == .remainingTime }
        set { setDisplayMode(newValue ? .remainingTime : .endTime) }
    }

    // MARK: - Actions

    /// 메뉴바 표시 모드를 변경하고 저장합니다.
    func setDisplayMode(_ mode: DisplayMode) {
        displayMode = mode
        UserDefaultsManager.shared.displayMode = mode
    }

    /// Selects a sprite at the given index and saves to UserDefaultsManager.
    func selectSprite(at index: Int) {
        guard index >= 0 && index < spriteOptions.count else { return }
        selectedSpriteIndex = index
        UserDefaultsManager.shared.selectedSpriteIndex = index
    }

    /// Navigates back to the dashboard.
    func goBack() {
        navigate?(.dashboard)
    }
}
