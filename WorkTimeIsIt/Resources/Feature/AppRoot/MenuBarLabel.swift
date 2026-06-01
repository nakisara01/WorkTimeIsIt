//
//  MenuBarLabel.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

/// A lightweight view that renders the menu bar animated sprite icon and time text.
///
/// This view appears in the macOS menu bar and shows:
/// - An animated sprite icon from the selected sprite sheet (5×5 grid, 25 frames)
/// - The remaining time (e.g. "3:42:13") or end time (e.g. "18:00")
///   depending on the user's selected `DisplayMode`.
///
/// The animation runs at ~8 FPS via a Timer, cycling through all 25 frames.
struct MenuBarLabel: View {
    let timeManager: TimeManager
    let spriteRenderer: StatusItemSpriteRenderer
    let settingsManager: UserDefaultsManager

    /// Current animation frame index (0-24), advanced by timer.
    @State private var beat: Int = 0

    /// Timer that drives the sprite animation.
    @State private var animationTimer: Timer?

    /// The current rendered sprite frame as NSImage.
    @State private var currentFrame: NSImage?

    /// Animation speed: frames per second
    private let fps: Double = 8.0

    var body: some View {
        HStack(spacing: 2) {
            spriteIcon
            fixedWidthTimeText
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }

    // MARK: - Private

    /// Renders the current animation frame of the selected sprite.
    private var spriteIcon: some View {
        Group {
            if let frame = currentFrame {
                Image(nsImage: frame)
            } else {
                Image(systemName: "clock")
            }
        }
    }

    /// Starts the animation timer.
    private func startAnimation() {
        updateFrame()
        let interval = 1.0 / fps
        animationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            Task { @MainActor in
                beat = (beat + 1) % spriteRenderer.totalFrameCount
                updateFrame()
            }
        }
    }

    /// Stops the animation timer.
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    /// Updates the current frame image from the renderer.
    /// Reads settingsManager.selectedSpriteIndex directly to ensure
    /// the icon always reflects the latest user selection.
    private func updateFrame() {
        currentFrame = spriteRenderer.frame(forSpriteIndex: settingsManager.selectedSpriteIndex, beat: beat)
    }

    private var displayText: String {
        switch settingsManager.displayMode {
        case .remainingTime:
            return formattedRemainingTime
        case .endTime:
            return formattedEndTime
        }
    }
    
    /// 숫자 폭 변화로 메뉴바 아이콘이 흔들리지 않도록 고정 너비 텍스트를 사용합니다.
    private var fixedWidthTimeText: some View {
        Text(displayText)
            .font(.system(size: 13, weight: .regular, design: .monospaced))
            .lineLimit(1)
            .frame(width: fixedWidthForDisplayMode, alignment: .leading)
    }

    private var fixedWidthForDisplayMode: CGFloat {
        switch settingsManager.displayMode {
        case .remainingTime:
            return 66
        case .endTime:
            return 42
        }
    }

    /// Formats the remaining seconds as "H:MM:SS".
    private var formattedRemainingTime: String {
        let total = Int(max(timeManager.remainingSeconds, 0))
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }

    /// Formats the work end time as "HH:MM" in 24-hour format.
    private var formattedEndTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timeManager.endTime)
    }
}
