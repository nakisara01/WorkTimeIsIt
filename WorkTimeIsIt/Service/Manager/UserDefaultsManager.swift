//
//  UserDefaultsManager.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation
import SwiftUI

// MARK: - UserDefaults 관리자
/// 앱의 사용자 설정을 UserDefaults에 저장하고 불러오는 싱글톤 매니저입니다.
/// 출퇴근 시간, 점심 시간, 디스플레이 모드 등의 설정을 관리합니다.
///
/// 사용 예시:
/// ```swift
/// let settings = UserDefaultsManager.shared
/// print(settings.endTimeHour) // 18
/// settings.endTimeHour = 19
/// ```
@MainActor
@Observable
final class UserDefaultsManager {
    
    // MARK: - 싱글톤
    
    /// 공유 인스턴스
    static let shared = UserDefaultsManager()
    
    /// UserDefaults 인스턴스
    private let defaults = UserDefaults.standard
    
    // MARK: - 출근 시간 설정
    
    /// 출근 시간 - 시 (0-23, 기본값: 9)
    var startTimeHour: Int {
        didSet { defaults.set(startTimeHour, forKey: Constants.UserDefaultsKeys.startTimeHour) }
    }
    
    /// 출근 시간 - 분 (0-59, 기본값: 0)
    var startTimeMinute: Int {
        didSet { defaults.set(startTimeMinute, forKey: Constants.UserDefaultsKeys.startTimeMinute) }
    }
    
    // MARK: - 퇴근 시간 설정
    
    /// 퇴근 시간 - 시 (0-23, 기본값: 18)
    var endTimeHour: Int {
        didSet { defaults.set(endTimeHour, forKey: Constants.UserDefaultsKeys.endTimeHour) }
    }
    
    /// 퇴근 시간 - 분 (0-59, 기본값: 0)
    var endTimeMinute: Int {
        didSet { defaults.set(endTimeMinute, forKey: Constants.UserDefaultsKeys.endTimeMinute) }
    }
    
    /// 총 업무 시간 (시간 단위, 기본값: 8.0)
    var totalWorkHours: Double {
        didSet { defaults.set(totalWorkHours, forKey: Constants.UserDefaultsKeys.totalWorkHours) }
    }
    
    // MARK: - 디스플레이 설정
    
    /// 메뉴 바 표시 모드 (남은 시간 / 퇴근 시간)
    var displayMode: DisplayMode {
        didSet { defaults.set(displayMode.rawValue, forKey: Constants.UserDefaultsKeys.displayMode) }
    }
    
    // MARK: - 초과근무 설정
    
    /// 초과근무 활성화 여부 (기본값: false)
    var overtimeEnabled: Bool {
        didSet { defaults.set(overtimeEnabled, forKey: Constants.UserDefaultsKeys.overtimeEnabled) }
    }
    
    /// 초과근무 시간 (기본값: 1시간)
    var overtimeHours: Int {
        didSet { defaults.set(overtimeHours, forKey: Constants.UserDefaultsKeys.overtimeHours) }
    }
    
    // MARK: - 점심 시간 설정
    
    /// 점심 시간 사용 여부 (기본값: true)
    var lunchBreakEnabled: Bool {
        didSet { defaults.set(lunchBreakEnabled, forKey: Constants.UserDefaultsKeys.lunchBreakEnabled) }
    }
    
    /// 점심 시작 시간 - 시 (기본값: 12)
    var lunchStartHour: Int {
        didSet { defaults.set(lunchStartHour, forKey: Constants.UserDefaultsKeys.lunchStartHour) }
    }
    
    /// 점심 시작 시간 - 분 (기본값: 0)
    var lunchStartMinute: Int {
        didSet { defaults.set(lunchStartMinute, forKey: Constants.UserDefaultsKeys.lunchStartMinute) }
    }
    
    /// 점심 종료 시간 - 시 (기본값: 13)
    var lunchEndHour: Int {
        didSet { defaults.set(lunchEndHour, forKey: Constants.UserDefaultsKeys.lunchEndHour) }
    }
    
    /// 점심 종료 시간 - 분 (기본값: 0)
    var lunchEndMinute: Int {
        didSet { defaults.set(lunchEndMinute, forKey: Constants.UserDefaultsKeys.lunchEndMinute) }
    }
    
    // MARK: - 스프라이트 설정
    
    /// 선택된 캐릭터/스프라이트 인덱스 (기본값: 0)
    var selectedSpriteIndex: Int {
        didSet { defaults.set(selectedSpriteIndex, forKey: Constants.UserDefaultsKeys.selectedSpriteIndex) }
    }
    
    // MARK: - 초기화
    
    private init() {
        // 기본값 등록 (최초 실행 시에만 적용)
        let defaultValues: [String: Any] = [
            Constants.UserDefaultsKeys.startTimeHour: Constants.defaultStartHour,
            Constants.UserDefaultsKeys.startTimeMinute: Constants.defaultStartMinute,
            Constants.UserDefaultsKeys.endTimeHour: Constants.defaultEndHour,
            Constants.UserDefaultsKeys.endTimeMinute: Constants.defaultEndMinute,
            Constants.UserDefaultsKeys.totalWorkHours: 8.0,
            Constants.UserDefaultsKeys.displayMode: DisplayMode.remainingTime.rawValue,
            Constants.UserDefaultsKeys.overtimeEnabled: false,
            Constants.UserDefaultsKeys.overtimeHours: 1,
            Constants.UserDefaultsKeys.lunchBreakEnabled: true,
            Constants.UserDefaultsKeys.lunchStartHour: Constants.defaultLunchStartHour,
            Constants.UserDefaultsKeys.lunchStartMinute: Constants.defaultLunchStartMinute,
            Constants.UserDefaultsKeys.lunchEndHour: Constants.defaultLunchEndHour,
            Constants.UserDefaultsKeys.lunchEndMinute: Constants.defaultLunchEndMinute,
            Constants.UserDefaultsKeys.selectedSpriteIndex: 0
        ]
        defaults.register(defaults: defaultValues)
        
        // 저장된 값 로드
        self.startTimeHour = defaults.integer(forKey: Constants.UserDefaultsKeys.startTimeHour)
        self.startTimeMinute = defaults.integer(forKey: Constants.UserDefaultsKeys.startTimeMinute)
        self.endTimeHour = defaults.integer(forKey: Constants.UserDefaultsKeys.endTimeHour)
        self.endTimeMinute = defaults.integer(forKey: Constants.UserDefaultsKeys.endTimeMinute)
        self.totalWorkHours = defaults.double(forKey: Constants.UserDefaultsKeys.totalWorkHours)
        
        let modeRawValue = defaults.string(forKey: Constants.UserDefaultsKeys.displayMode) ?? DisplayMode.remainingTime.rawValue
        self.displayMode = DisplayMode(rawValue: modeRawValue) ?? .remainingTime
        
        self.overtimeEnabled = defaults.bool(forKey: Constants.UserDefaultsKeys.overtimeEnabled)
        self.overtimeHours = defaults.integer(forKey: Constants.UserDefaultsKeys.overtimeHours)
        self.lunchBreakEnabled = defaults.bool(forKey: Constants.UserDefaultsKeys.lunchBreakEnabled)
        self.lunchStartHour = defaults.integer(forKey: Constants.UserDefaultsKeys.lunchStartHour)
        self.lunchStartMinute = defaults.integer(forKey: Constants.UserDefaultsKeys.lunchStartMinute)
        self.lunchEndHour = defaults.integer(forKey: Constants.UserDefaultsKeys.lunchEndHour)
        self.lunchEndMinute = defaults.integer(forKey: Constants.UserDefaultsKeys.lunchEndMinute)
        self.selectedSpriteIndex = defaults.integer(forKey: Constants.UserDefaultsKeys.selectedSpriteIndex)
    }
    
    // MARK: - 편의 메서드
    
    /// 출근 시간을 Date 객체로 반환합니다 (오늘 날짜 기준)
    var startTimeDate: Date {
        Date.todayAt(hour: startTimeHour, minute: startTimeMinute)
    }
    
    /// 퇴근 시간을 Date 객체로 반환합니다 (오늘 날짜 기준)
    var endTimeDate: Date {
        Date.todayAt(hour: endTimeHour, minute: endTimeMinute)
    }
    
    /// 점심 시작 시간을 Date 객체로 반환합니다 (오늘 날짜 기준)
    var lunchStartDate: Date {
        Date.todayAt(hour: lunchStartHour, minute: lunchStartMinute)
    }
    
    /// 점심 종료 시간을 Date 객체로 반환합니다 (오늘 날짜 기준)
    var lunchEndDate: Date {
        Date.todayAt(hour: lunchEndHour, minute: lunchEndMinute)
    }
    
    /// 초과근무 종료 시간을 Date 객체로 반환합니다 (오늘 날짜 기준)
    var overtimeEndDate: Date? {
        guard overtimeEnabled else { return nil }
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: overtimeHours, to: endTimeDate)
    }
    
    /// 점심 시간 길이 (초 단위)
    var lunchBreakDuration: TimeInterval {
        guard lunchBreakEnabled else { return 0 }
        return lunchEndDate.timeIntervalSince(lunchStartDate)
    }
    
    /// 총 근무 시간 (초 단위, 점심 시간 제외)
    var totalWorkDuration: TimeInterval {
        let totalDuration = endTimeDate.timeIntervalSince(startTimeDate)
        return totalDuration - lunchBreakDuration
    }
    
    /// 모든 설정을 기본값으로 초기화합니다.
    func resetToDefaults() {
        startTimeHour = Constants.defaultStartHour
        startTimeMinute = Constants.defaultStartMinute
        endTimeHour = Constants.defaultEndHour
        endTimeMinute = Constants.defaultEndMinute
        totalWorkHours = 8.0
        displayMode = .remainingTime
        overtimeEnabled = false
        overtimeHours = 1
        lunchBreakEnabled = true
        lunchStartHour = Constants.defaultLunchStartHour
        lunchStartMinute = Constants.defaultLunchStartMinute
        lunchEndHour = Constants.defaultLunchEndHour
        lunchEndMinute = Constants.defaultLunchEndMinute
        selectedSpriteIndex = 0
    }
}
