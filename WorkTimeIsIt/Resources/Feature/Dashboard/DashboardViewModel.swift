//
//  DashboardViewModel.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - DashboardViewModel

@Observable
final class DashboardViewModel {

    // MARK: - Dependencies

    private let timeManager: TimeManager

    // MARK: - Display Properties

    /// Formatted remaining time for the large timer display
    var remainingTimeString: String {
        timeManager.remainingTimeString
    }

    /// Work progress as a fraction (0.0 to 1.0)
    var progress: Double {
        timeManager.progress
    }

    /// 시간 포맷터 (재사용)
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    /// Formatted start time (e.g., "09:00")
    var formattedStartTime: String {
        Self.timeFormatter.string(from: timeManager.startTime)
    }

    /// Formatted end time (e.g., "18:00")
    var formattedEndTime: String {
        Self.timeFormatter.string(from: timeManager.endTime)
    }

    /// Whether the user is currently within working hours
    var isWorking: Bool {
        timeManager.isWorking
    }

    /// 업무 완료 여부
    var isCompleted: Bool {
        timeManager.isCompleted
    }

    /// 점심 시간 포맷 (예: "12:00 - 13:00")
    var formattedLunchTime: String {
        if timeManager.lunchBreakEnabled {
            return "\(Self.timeFormatter.string(from: timeManager.lunchStartTime)) - \(Self.timeFormatter.string(from: timeManager.lunchEndTime))"
        }
        return String(localized: "dashboard.noLunch")
    }

    /// Today's date formatted for display card
    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }

    /// Work hours description for display card
    var workHoursString: String {
        "\(formattedStartTime) - \(formattedEndTime)"
    }

    /// App version string
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return "v\(version)"
    }

    /// Status label text based on working state
    var statusLabel: String {
        if isCompleted {
            return String(localized: "dashboard.status.completed")
        } else if isWorking || timeManager.remainingSeconds > 0 {
            return String(localized: "dashboard.status.working")
        } else {
            return String(localized: "dashboard.status.ended")
        }
    }

    /// Progress percentage for display (e.g., "67%")
    var progressPercentage: String {
        "\(Int(progress * 100))%"
    }

    // MARK: - Initialization

    init(timeManager: TimeManager) {
        self.timeManager = timeManager
    }

    // MARK: - Actions

    /// Called when the Clock Out button is tapped
    func clockOut() {
        timeManager.clockOutNow()
    }
}
