//
//  DisplayMode.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

// MARK: - 디스플레이 모드
/// 메뉴 바에 표시할 시간 형식을 정의합니다.
/// 사용자가 남은 시간 또는 퇴근 시간 중 원하는 형식을 선택할 수 있습니다.
enum DisplayMode: String, CaseIterable, Codable {
    
    /// 남은 시간 표시 모드 (예: "03:24:15")
    case remainingTime
    
    /// 퇴근 시간 표시 모드 (예: "18:00")
    case endTime
    
    // MARK: - 표시 이름
    
    /// 사용자에게 보여줄 한국어 표시 이름
    var displayName: String {
        switch self {
        case .remainingTime:
            return "남은 시간"
        case .endTime:
            return "퇴근 시간"
        }
    }
    
    /// 메뉴 바에 표시할 설명 텍스트
    var description: String {
        switch self {
        case .remainingTime:
            return "퇴근까지 남은 시간을 표시합니다"
        case .endTime:
            return "퇴근 시간을 표시합니다"
        }
    }
}
