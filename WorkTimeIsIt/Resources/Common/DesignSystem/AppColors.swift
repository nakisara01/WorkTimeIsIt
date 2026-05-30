//
//  AppColors.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

// MARK: - 앱 컬러 시스템
/// 앱 전체에서 사용하는 색상을 정의합니다.
/// Figma 디자인 토큰을 기반으로 다크 테마 색상 팔레트를 구성합니다.
enum AppColors {
    
    // MARK: - 배경 (Background)
    
    /// 메인 배경색 (#0D1117) - 가장 어두운 배경
    static let background = Color(hex: "#0D1117")
    
    /// 카드 배경색 (#161B22) - 카드, 섹션 컨테이너 배경
    static let cardBackground = Color(hex: "#161B22")
    
    /// 입력 필드 배경색 (#21262D) - 텍스트 필드, 피커 배경
    static let inputBackground = Color(hex: "#21262D")
    
    // MARK: - 강조 (Accent)
    
    /// 기본 강조색 (#7C6AED) - 버튼, 활성 상태, 프로그레스 바
    static let accent = Color(hex: "#7C6AED")
    
    // MARK: - 텍스트 (Text)
    
    /// 기본 텍스트 색상 (#FFFFFF) - 제목, 타이머 숫자
    static let primaryText = Color(hex: "#FFFFFF")
    
    /// 보조 텍스트 색상 (#8B949E) - 설명문, 캡션, 라벨
    static let secondaryText = Color(hex: "#8B949E")
    
    // MARK: - 기능별 (Functional)
    
    /// 프로그레스 바 트랙 색상 (#21262D) - 프로그레스 바 배경
    static let progressTrack = Color(hex: "#21262D")
    
    /// 경고/삭제 색상 (#F85149) - 오류, 삭제 버튼, 초과 근무
    static let destructive = Color(hex: "#F85149")
    
    /// 성공/완료 색상 (#3FB950) - 성공 상태, 완료 표시
    static let success = Color(hex: "#3FB950")
}
