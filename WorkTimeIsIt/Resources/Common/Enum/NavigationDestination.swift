//
//  NavigationDestination.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

// MARK: - 네비게이션 목적지
/// 팝오버 내부의 화면 전환 목적지를 정의합니다.
/// 메뉴 바 팝오버에서 이동할 수 있는 모든 화면을 나타냅니다.
enum NavigationDestination: Hashable {
    
    /// 대시보드 화면 - 타이머 및 진행률 표시
    case dashboard
    
    /// 시간 설정 화면 - 출퇴근 시간, 점심시간 설정
    case timeSettings
    
    /// 환경설정 화면 - 앱 설정, 테마, 알림 등
    case preferences
    
    // MARK: - 표시 이름
    
    /// 각 화면의 한국어 제목
    var title: String {
        switch self {
        case .dashboard:
            return String(localized: "nav.dashboard")
        case .timeSettings:
            return String(localized: "nav.timeSettings")
        case .preferences:
            return String(localized: "nav.preferences")
        }
    }
    
    /// 각 화면에 대응하는 SF Symbol 아이콘 이름
    var iconName: String {
        switch self {
        case .dashboard:
            return "clock.fill"
        case .timeSettings:
            return "calendar.badge.clock"
        case .preferences:
            return "gearshape.fill"
        }
    }
}
