//
//  Constants.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

// MARK: - 앱 상수
/// 앱 전체에서 사용하는 상수를 정의합니다.
enum Constants {
    
    // MARK: - 앱 정보
    
    /// 앱 이름
    static let appName = "WorkTimeIsIt"
    
    /// 앱 표시 이름 (한국어)
    static let appDisplayName = String(localized: "app.displayName")
    
    /// 앱 버전 (Bundle에서 자동 읽기, 실패 시 기본값)
    static let appVersion: String = {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }()
    
    /// 앱 빌드 번호
    static let buildNumber: String = {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }()
    
    /// 번들 ID
    static let bundleID = "com.nahyunheum.WorkTimeIsIt"
    
    // MARK: - 타이머 설정
    
    /// 타이머 업데이트 간격 (초)
    static let timerUpdateInterval: TimeInterval = 1.0
    
    // MARK: - 기본 근무 시간
    
    /// 기본 출근 시간 (시)
    static let defaultStartHour = 9
    
    /// 기본 출근 시간 (분)
    static let defaultStartMinute = 0
    
    /// 기본 퇴근 시간 (시)
    static let defaultEndHour = 18
    
    /// 기본 퇴근 시간 (분)
    static let defaultEndMinute = 0
    
    // MARK: - 기본 점심 시간
    
    /// 기본 점심 시작 시간 (시)
    static let defaultLunchStartHour = 12
    
    /// 기본 점심 시작 시간 (분)
    static let defaultLunchStartMinute = 0
    
    /// 기본 점심 종료 시간 (시)
    static let defaultLunchEndHour = 13
    
    /// 기본 점심 종료 시간 (분)
    static let defaultLunchEndMinute = 0
    
    // MARK: - UserDefaults 키
    
    /// UserDefaults 키를 별도 enum으로 관리합니다.
    enum UserDefaultsKeys {
        static let startTimeHour = "startTimeHour"
        static let startTimeMinute = "startTimeMinute"
        static let endTimeHour = "endTimeHour"
        static let endTimeMinute = "endTimeMinute"
        static let totalWorkHours = "totalWorkHours"
        static let displayMode = "displayMode"
        static let overtimeEnabled = "overtimeEnabled"
        static let overtimeHours = "overtimeHours"
        static let lunchBreakEnabled = "lunchBreakEnabled"
        static let lunchStartHour = "lunchStartHour"
        static let lunchStartMinute = "lunchStartMinute"
        static let lunchEndHour = "lunchEndHour"
        static let lunchEndMinute = "lunchEndMinute"
        static let selectedSpriteIndex = "selectedSpriteIndex"
    }
}
