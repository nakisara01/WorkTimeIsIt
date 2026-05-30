//
//  TimeSettingsModel.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

/// Data model representing the user's work time configuration.
/// Holds start time, total work hours, overtime settings, and lunch break settings.
struct TimeSettingsData {
    /// 출근시간 (근무시작시간) - Work start time
    var startTime: Date

    /// 총 업무시간 (시간 단위, 기본값: 8.0)
    var totalWorkHours: Double

    /// 야근 모드 활성화 여부
    var overtimeEnabled: Bool

    /// 야근 추가 시간 (hours)
    var overtimeHours: Double

    /// 점심시간 제외 활성화 여부
    var lunchBreakEnabled: Bool

    /// 점심시간 시작
    var lunchStartTime: Date

    /// 점심시간 종료
    var lunchEndTime: Date

    /// Creates a default time settings configuration.
    /// Default: 09:00 AM start, 8 hours work, no overtime, lunch 12:00 - 13:00.
    static var `default`: TimeSettingsData {
        let calendar = Calendar.current
        let now = Date()

        let startTime = calendar.date(
            bySettingHour: 9, minute: 0, second: 0, of: now
        ) ?? now

        let lunchStart = calendar.date(
            bySettingHour: 12, minute: 0, second: 0, of: now
        ) ?? now

        let lunchEnd = calendar.date(
            bySettingHour: 13, minute: 0, second: 0, of: now
        ) ?? now

        return TimeSettingsData(
            startTime: startTime,
            totalWorkHours: 8.0,
            overtimeEnabled: false,
            overtimeHours: 1.0,
            lunchBreakEnabled: false,
            lunchStartTime: lunchStart,
            lunchEndTime: lunchEnd
        )
    }
}
