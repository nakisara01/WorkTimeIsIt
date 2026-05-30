//
//  DashboardModel.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

// MARK: - Dashboard Display Data

/// Contains all formatted values ready for display in the Dashboard view.
struct DashboardData {
    /// Formatted remaining time string (e.g., "03:42:13")
    let remainingTime: String

    /// Work progress as a value between 0.0 and 1.0
    let progress: Double

    /// Formatted start time string (e.g., "09:00")
    let startTime: String

    /// Formatted end time string (e.g., "18:00")
    let endTime: String

    /// Whether the user is currently in working hours
    let isWorking: Bool

    /// Today's date formatted for display (e.g., "5월 29일 목요일")
    let todayDateString: String

    /// Total work hours description (e.g., "9시간 근무")
    let workHoursString: String

    static let placeholder = DashboardData(
        remainingTime: "--:--:--",
        progress: 0.0,
        startTime: "--:--",
        endTime: "--:--",
        isWorking: false,
        todayDateString: "",
        workHoursString: ""
    )
}

// MARK: - Dashboard Input Data

/// Dashboard 입력 모드에서 사용하는 데이터 모델입니다.
/// 체크인 시간, 점심 시간, 총 업무시간을 입력받아 퇴근 시간을 계산합니다.
struct DashboardInputData {
    /// 체크인(출근) 시간
    var checkInTime: Date

    /// 점심 시간 사용 여부
    var lunchEnabled: Bool

    /// 점심 시작 시간
    var lunchStartTime: Date

    /// 점심 종료 시간
    var lunchEndTime: Date

    /// 총 업무 시간 (시간 단위, 예: 8.0 = 8시간)
    var totalWorkHours: Double

    /// 퇴근 시간 (자동 계산)
    var calculatedEndTime: Date {
        let workInterval = totalWorkHours * 3600
        let lunchInterval = lunchEnabled ? lunchEndTime.timeIntervalSince(lunchStartTime) : 0
        return checkInTime.addingTimeInterval(workInterval + lunchInterval)
    }

    /// 기본값 생성 (현재 시간 기준)
    static func makeDefault() -> DashboardInputData {
        let calendar = Calendar.current
        let now = Date()

        let lunchStart = calendar.date(
            bySettingHour: 12, minute: 0, second: 0, of: now
        ) ?? now

        let lunchEnd = calendar.date(
            bySettingHour: 13, minute: 0, second: 0, of: now
        ) ?? now

        return DashboardInputData(
            checkInTime: now,
            lunchEnabled: true,
            lunchStartTime: lunchStart,
            lunchEndTime: lunchEnd,
            totalWorkHours: 8.0
        )
    }
}

// MARK: - Work Info

/// Represents the user's work schedule configuration.
struct WorkInfo {
    /// Work start time
    let startTime: Date

    /// Work end time
    let endTime: Date

    /// Total work hours (computed from start/end)
    var totalHours: Double {
        endTime.timeIntervalSince(startTime) / 3600.0
    }

    /// Formatted total hours string for display
    var formattedTotalHours: String {
        let hours = Int(totalHours)
        let minutes = Int((totalHours - Double(hours)) * 60)
        if minutes == 0 {
            return String(format: String(localized: "format.hours"), hours)
        }
        return String(format: String(localized: "format.hoursMinutes"), hours, minutes)
    }
}
