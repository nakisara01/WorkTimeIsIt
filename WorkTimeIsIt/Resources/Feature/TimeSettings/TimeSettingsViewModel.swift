//
//  TimeSettingsViewModel.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

/// ViewModel managing the time settings form state and persistence.
/// Uses @Observable macro for modern SwiftUI state management.
///
/// 총 업무시간을 입력하면 퇴근 시간을 자동으로 계산합니다.
/// 퇴근 시간 = 출근 시간 + 총 업무시간 + 점심 시간
@Observable
final class TimeSettingsViewModel {
    // MARK: - Form State (Date-based for DatePicker bindings)

    /// 출근시간 (근무시작시간)
    var startTime: Date

    /// 총 업무시간 (시간 단위, 0.5시간 단위로 조정)
    var totalWorkHours: Double

    /// 야근 모드 활성화
    var overtimeEnabled: Bool

    /// 야근 추가 시간 (hours)
    var overtimeHours: Double

    /// 점심시간 설정 활성화
    var lunchBreakEnabled: Bool

    /// 점심시간 시작
    var lunchStartTime: Date

    /// 점심시간 종료
    var lunchEndTime: Date

    /// Indicates whether a save operation was recently completed (for feedback UI).
    var isSaved: Bool = false

    // MARK: - Computed: 퇴근 시간 자동 계산

    /// 퇴근 시간 (자동 계산: 출근 + 총 업무시간 + 점심)
    var calculatedEndTime: Date {
        let workInterval = totalWorkHours * 3600
        let lunchInterval = lunchBreakEnabled ? lunchEndTime.timeIntervalSince(lunchStartTime) : 0
        return startTime.addingTimeInterval(workInterval + lunchInterval)
    }

    /// 총 업무시간 표시 문자열
    var totalWorkHoursString: String {
        let hours = Int(totalWorkHours)
        let minutes = Int((totalWorkHours - Double(hours)) * 60)
        if minutes == 0 {
            return String(format: String(localized: "format.hours"), hours)
        }
        return String(format: String(localized: "format.hoursMinutes"), hours, minutes)
    }

    /// 시간 포맷터
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    /// 계산된 퇴근 시간 표시 문자열
    var formattedEndTime: String {
        Self.timeFormatter.string(from: calculatedEndTime)
    }

    // MARK: - Navigation

    /// Callback to navigate to a different screen.
    var navigate: ((NavigationDestination) -> Void)?

    // MARK: - Initialization

    init(navigate: ((NavigationDestination) -> Void)? = nil) {
        let defaults = TimeSettingsData.default
        self.startTime = defaults.startTime
        self.totalWorkHours = defaults.totalWorkHours
        self.overtimeEnabled = defaults.overtimeEnabled
        self.overtimeHours = defaults.overtimeHours
        self.lunchBreakEnabled = defaults.lunchBreakEnabled
        self.lunchStartTime = defaults.lunchStartTime
        self.lunchEndTime = defaults.lunchEndTime
        self.navigate = navigate

        load()
    }

    // MARK: - Persistence

    /// Loads saved time settings from UserDefaultsManager.
    /// Converts integer hour/minute values to Date objects for DatePicker bindings.
    @MainActor
    func load() {
        let manager = UserDefaultsManager.shared
        let calendar = Calendar.current
        let today = Date()

        startTime = calendar.date(
            bySettingHour: manager.startTimeHour,
            minute: manager.startTimeMinute,
            second: 0,
            of: today
        ) ?? startTime

        totalWorkHours = manager.totalWorkHours

        overtimeEnabled = manager.overtimeEnabled
        overtimeHours = Double(manager.overtimeHours)

        lunchBreakEnabled = manager.lunchBreakEnabled

        lunchStartTime = calendar.date(
            bySettingHour: manager.lunchStartHour,
            minute: manager.lunchStartMinute,
            second: 0,
            of: today
        ) ?? lunchStartTime

        lunchEndTime = calendar.date(
            bySettingHour: manager.lunchEndHour,
            minute: manager.lunchEndMinute,
            second: 0,
            of: today
        ) ?? lunchEndTime
    }

    /// Saves the current form state to UserDefaultsManager.
    /// 퇴근 시간은 출근 + 총 업무시간 + 점심으로 자동 계산하여 저장합니다.
    @MainActor
    func save() {
        let manager = UserDefaultsManager.shared
        let calendar = Calendar.current

        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        manager.startTimeHour = startComponents.hour ?? 9
        manager.startTimeMinute = startComponents.minute ?? 0

        // 총 업무시간 저장
        manager.totalWorkHours = totalWorkHours

        // 퇴근 시간은 자동 계산하여 저장
        let endComponents = calendar.dateComponents([.hour, .minute], from: calculatedEndTime)
        manager.endTimeHour = endComponents.hour ?? 18
        manager.endTimeMinute = endComponents.minute ?? 0

        manager.overtimeEnabled = overtimeEnabled
        manager.overtimeHours = Int(overtimeHours)

        manager.lunchBreakEnabled = lunchBreakEnabled

        let lunchStartComponents = calendar.dateComponents([.hour, .minute], from: lunchStartTime)
        manager.lunchStartHour = lunchStartComponents.hour ?? 12
        manager.lunchStartMinute = lunchStartComponents.minute ?? 0

        let lunchEndComponents = calendar.dateComponents([.hour, .minute], from: lunchEndTime)
        manager.lunchEndHour = lunchEndComponents.hour ?? 13
        manager.lunchEndMinute = lunchEndComponents.minute ?? 0

        // Show save feedback
        isSaved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isSaved = false
        }
    }

    /// Navigates back to the dashboard.
    func goBack() {
        navigate?(.dashboard)
    }
}
