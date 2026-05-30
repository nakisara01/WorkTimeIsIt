//
//  TimeManager.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation
import SwiftUI

// MARK: - 시간 관리자
/// 타이머 로직을 담당하는 핵심 매니저입니다.
/// 매 초마다 남은 시간을 계산하고, 프로그레스 바 진행률을 업데이트합니다.
/// 점심 시간과 초과근무를 고려한 계산을 수행합니다.
///
/// 사용 예시:
/// ```swift
/// let timeManager = TimeManager()
/// timeManager.startTimer()
/// print(timeManager.remainingTimeString) // "03:24:15"
/// ```
@MainActor
@Observable
final class TimeManager {
    
    // MARK: - 표시용 프로퍼티
    
    /// 남은 시간 문자열 (HH:MM:SS 형식)
    private(set) var remainingTimeString: String = "00:00:00"
    
    /// 남은 시간 (초 단위)
    private(set) var remainingSeconds: TimeInterval = 0
    
    /// 진행률 (0.0 ~ 1.0, 퇴근 시간에 가까울수록 1.0)
    private(set) var progress: Double = 0.0
    
    // MARK: - 시간 설정
    
    /// 출근 시간
    private(set) var startTime: Date = Date()
    
    /// 퇴근 시간
    private(set) var endTime: Date = Date()
    
    /// 현재 근무 중인지 여부
    private(set) var isWorking: Bool = false
    
    /// 업무 완료 여부 (타이머가 0에 도달했을 때 true)
    private(set) var isCompleted: Bool = false
    
    // MARK: - 초과근무 관련
    
    /// 초과근무 활성화 여부
    private(set) var overtimeEnabled: Bool = false
    
    /// 초과근무 종료 시간
    private(set) var overtimeEndTime: Date?
    
    // MARK: - 점심시간 관련
    
    /// 점심시간 활성화 여부
    private(set) var lunchBreakEnabled: Bool = false
    
    /// 점심 시작 시간
    private(set) var lunchStartTime: Date = Date()
    
    /// 점심 종료 시간
    private(set) var lunchEndTime: Date = Date()
    
    // MARK: - 내부 프로퍼티
    
    /// 타이머 인스턴스
    private var timer: Timer?
    
    /// UserDefaults 매니저 참조
    private let settings: UserDefaultsManager
    
    // MARK: - 초기화
    
    /// TimeManager를 초기화합니다.
    /// - Parameter settings: UserDefaults 매니저 (기본값: 공유 인스턴스)
    init(settings: UserDefaultsManager = .shared) {
        self.settings = settings
        loadSettings()
    }
    
    
    
    // MARK: - 공개 메서드
    
    /// 타이머를 시작합니다. 매 초마다 남은 시간을 업데이트합니다.
    func startTimer() {
        // 설정을 다시 로드하여 최신 값 반영
        loadSettings()
        
        // 기존 타이머 중지
        timer?.invalidate()
        
        // 완료 상태 초기화
        isCompleted = false
        
        // 즉시 한 번 업데이트
        updateTime()
        
        // 매 초마다 업데이트
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.timerUpdateInterval,
            repeats: true
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateTime()
            }
        }
    }
    
    /// 타이머를 중지합니다.
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 설정을 다시 로드하고 타이머를 재시작합니다.
    func reloadSettings() {
        loadSettings()
        updateTime()
    }
    
    /// Dashboard에서 입력받은 값으로 시간을 설정하고 타이머를 시작합니다.
    /// - Parameters:
    ///   - checkInTime: 체크인(출근) 시간
    ///   - lunchStart: 점심 시작 시간
    ///   - lunchEnd: 점심 종료 시간
    ///   - totalWorkHours: 총 업무 시간 (시간 단위)
    ///   - lunchEnabled: 점심 시간 사용 여부
    func configureFromDashboard(
        checkInTime: Date,
        lunchStart: Date,
        lunchEnd: Date,
        totalWorkHours: Double,
        lunchEnabled: Bool
    ) {
        self.startTime = checkInTime
        self.lunchBreakEnabled = lunchEnabled
        self.lunchStartTime = lunchStart
        self.lunchEndTime = lunchEnd
        
        // 퇴근 시간 = 체크인 시간 + 총 업무시간 + 점심 시간
        let workInterval = totalWorkHours * 3600
        let lunchInterval = lunchEnabled ? lunchEnd.timeIntervalSince(lunchStart) : 0
        self.endTime = checkInTime.addingTimeInterval(workInterval + lunchInterval)
        
        // 완료 상태 초기화
        isCompleted = false
        
        // 기존 타이머 중지 후 새로 시작
        timer?.invalidate()
        updateTime()
        
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.timerUpdateInterval,
            repeats: true
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateTime()
            }
        }
    }
    
    // MARK: - 내부 메서드
    
    /// UserDefaultsManager에서 설정값을 로드합니다.
    private func loadSettings() {
        startTime = settings.startTimeDate
        endTime = settings.endTimeDate
        overtimeEnabled = settings.overtimeEnabled
        overtimeEndTime = settings.overtimeEndDate
        lunchBreakEnabled = settings.lunchBreakEnabled
        lunchStartTime = settings.lunchStartDate
        lunchEndTime = settings.lunchEndDate
    }
    
    /// 현재 시간을 기준으로 남은 시간과 진행률을 업데이트합니다.
    private func updateTime() {
        let now = Date()
        
        // 실제 목표 시간 결정 (초과근무 고려)
        let targetEndTime = overtimeEnabled ? (overtimeEndTime ?? endTime) : endTime
        
        // 근무 중 여부 판단
        isWorking = now >= startTime && now <= targetEndTime
        
        // 남은 시간 계산 (점심 시간 고려)
        let rawRemaining = targetEndTime.timeIntervalSince(now)
        let lunchDeduction = calculateLunchDeduction(now: now, targetEnd: targetEndTime)
        remainingSeconds = max(0, rawRemaining - lunchDeduction)
        
        // HH:MM:SS 형식으로 변환
        remainingTimeString = formatTimeInterval(remainingSeconds)
        
        // 진행률 계산
        progress = calculateProgress(now: now, targetEnd: targetEndTime)
        
        // 자동 정지: 남은 시간이 0 이하이고 아직 완료 처리 안 된 경우
        if remainingSeconds <= 0 && !isCompleted && now >= startTime {
            isCompleted = true
            isWorking = false
            stopTimer()
        }
    }
    
    /// 점심 시간 차감량을 계산합니다.
    /// - Parameters:
    ///   - now: 현재 시간
    ///   - targetEnd: 목표 종료 시간
    /// - Returns: 차감할 점심 시간 (초 단위)
    private func calculateLunchDeduction(now: Date, targetEnd: Date) -> TimeInterval {
        guard lunchBreakEnabled else { return 0 }
        
        // 점심 시간이 아직 시작되지 않은 경우: 전체 점심 시간 차감
        if now < lunchStartTime {
            return lunchEndTime.timeIntervalSince(lunchStartTime)
        }
        
        // 점심 시간 중인 경우: 남은 점심 시간만 차감
        if now >= lunchStartTime && now < lunchEndTime {
            return lunchEndTime.timeIntervalSince(now)
        }
        
        // 점심 시간이 지난 경우: 차감 없음
        return 0
    }
    
    /// 진행률을 계산합니다 (0.0 ~ 1.0).
    /// - Parameters:
    ///   - now: 현재 시간
    ///   - targetEnd: 목표 종료 시간
    /// - Returns: 진행률 (0.0 = 출근, 1.0 = 퇴근)
    private func calculateProgress(now: Date, targetEnd: Date) -> Double {
        let totalWorkDuration = targetEnd.timeIntervalSince(startTime) - (lunchBreakEnabled ? lunchEndTime.timeIntervalSince(lunchStartTime) : 0)
        
        guard totalWorkDuration > 0 else { return 0 }
        
        // 출근 전
        if now < startTime { return 0 }
        
        // 퇴근 후
        if now > targetEnd { return 1.0 }
        
        // 근무 중: 경과 시간 / 총 근무 시간
        let elapsed = now.timeIntervalSince(startTime) - calculateElapsedLunchTime(now: now)
        let result = elapsed / totalWorkDuration
        
        return min(max(result, 0), 1.0)
    }
    
    /// 현재까지 경과한 점심 시간을 계산합니다.
    /// - Parameter now: 현재 시간
    /// - Returns: 경과한 점심 시간 (초 단위)
    private func calculateElapsedLunchTime(now: Date) -> TimeInterval {
        guard lunchBreakEnabled else { return 0 }
        
        // 점심 시간 전
        if now < lunchStartTime { return 0 }
        
        // 점심 시간 중
        if now < lunchEndTime {
            return now.timeIntervalSince(lunchStartTime)
        }
        
        // 점심 시간 후: 전체 점심 시간
        return lunchEndTime.timeIntervalSince(lunchStartTime)
    }
    
    /// TimeInterval을 HH:MM:SS 문자열로 변환합니다.
    /// - Parameter interval: 시간 간격 (초 단위)
    /// - Returns: "HH:MM:SS" 형식의 문자열
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        guard interval > 0 else { return "00:00:00" }
        
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
