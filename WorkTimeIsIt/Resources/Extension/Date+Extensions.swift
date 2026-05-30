//
//  Date+Extensions.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

// MARK: - Date 확장
/// 시간 포맷팅 및 날짜 계산을 위한 Date 확장입니다.
/// 타이머 표시, 시간 설정 등에서 활용됩니다.
extension Date {
    
    // MARK: - 포맷터 (캐싱으로 성능 최적화)
    
    /// 24시간 형식 포맷터 (HH:mm)
    private static let timeFormatter24: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    /// 12시간 AM/PM 형식 포맷터 (h:mm a)
    private static let timeFormatterAMPM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    // MARK: - 시간 포맷팅
    
    /// 24시간 형식으로 포맷팅합니다 (예: "18:30")
    func formattedTime() -> String {
        Date.timeFormatter24.string(from: self)
    }
    
    /// 12시간 AM/PM 형식으로 포맷팅합니다 (예: "오후 6:30")
    func formattedTimeAMPM() -> String {
        Date.timeFormatterAMPM.string(from: self)
    }
    
    // MARK: - 날짜 계산
    
    /// 오늘 날짜의 시작 (00:00:00)
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// 오늘 날짜의 끝 (23:59:59)
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    // MARK: - 카운트다운 설명
    
    /// 특정 시간까지 남은 시간을 사람이 읽기 쉬운 형태로 반환합니다.
    /// - Parameter targetDate: 목표 시간
    /// - Returns: 남은 시간 문자열 (예: "3시간 24분 남음", "퇴근 시간이 지났습니다")
    func timeIntervalDescription(from targetDate: Date) -> String {
        let interval = targetDate.timeIntervalSince(self)
        
        if interval <= 0 {
            return "퇴근 시간이 지났습니다"
        }
        
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return "\(hours)시간 \(minutes)분 남음"
        } else if minutes > 0 {
            return "\(minutes)분 \(seconds)초 남음"
        } else {
            return "\(seconds)초 남음"
        }
    }
    
    // MARK: - 시간 컴포넌트 접근
    
    /// 현재 시간의 시(hour) 컴포넌트 (0-23)
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    /// 현재 시간의 분(minute) 컴포넌트 (0-59)
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    /// 현재 시간의 초(second) 컴포넌트 (0-59)
    var second: Int {
        Calendar.current.component(.second, from: self)
    }
    
    // MARK: - 날짜 생성 유틸리티
    
    /// 오늘 날짜에 특정 시:분을 설정한 Date를 생성합니다.
    /// - Parameters:
    ///   - hour: 시간 (0-23)
    ///   - minute: 분 (0-59)
    /// - Returns: 설정된 시간의 Date 객체
    static func todayAt(hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        components.second = 0
        return calendar.date(from: components) ?? Date()
    }
}
