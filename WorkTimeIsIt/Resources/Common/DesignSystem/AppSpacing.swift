//
//  AppSpacing.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation

// MARK: - 앱 간격 및 레이아웃 상수
/// 앱 전체에서 사용하는 간격, 코너 반경, 팝오버 크기 상수를 정의합니다.
/// Figma 디자인 시스템의 스페이싱 토큰을 기반으로 합니다.
enum AppSpacing {
    
    // MARK: - 간격 (Spacing)
    
    /// 아주 작은 간격 - 4pt
    static let xs: CGFloat = 4
    
    /// 작은 간격 - 8pt
    static let sm: CGFloat = 8
    
    /// 중간 간격 - 12pt
    static let md: CGFloat = 12
    
    /// 큰 간격 - 16pt
    static let lg: CGFloat = 16
    
    /// 아주 큰 간격 - 20pt
    static let xl: CGFloat = 20
    
    /// 가장 큰 간격 - 24pt
    static let xxl: CGFloat = 24
    
    // MARK: - 코너 반경 (Corner Radius)
    
    /// 작은 코너 반경 - 버튼, 입력 필드용 (8pt)
    static let cornerRadiusSmall: CGFloat = 8
    
    /// 큰 코너 반경 - 카드, 컨테이너용 (12pt)
    static let cornerRadiusLarge: CGFloat = 12
    
    // MARK: - 팝오버 크기 (Popover Dimensions)
    
    /// 팝오버 너비 - 메뉴 바 팝오버의 고정 너비 (280pt)
    static let popoverWidth: CGFloat = 280
}
