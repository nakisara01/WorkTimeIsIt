//
//  AppFonts.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

// MARK: - 앱 폰트 시스템
/// 앱 전체에서 사용하는 폰트를 정의합니다.
/// SF Pro (시스템 폰트)와 SF Mono (모노스페이스)를 사용합니다.
enum AppFonts {
    
    /// 타이머 표시용 대형 모노스페이스 폰트 (SF Mono, 44pt, Bold)
    /// - 카운트다운 타이머의 숫자 표시에 사용
    static func timer() -> Font {
        .system(size: 44, design: .monospaced).bold()
    }
    
    /// 제목용 폰트 (SF Pro, 18pt, Semibold)
    /// - 섹션 헤더, 카드 제목 등에 사용
    static func title() -> Font {
        .system(size: 18, weight: .semibold)
    }
    
    /// 본문용 폰트 (SF Pro, 14pt, Regular)
    /// - 일반 텍스트, 설명문 등에 사용
    static func body() -> Font {
        .system(size: 14)
    }
    
    /// 캡션용 폰트 (SF Pro, 12pt, Regular)
    /// - 보조 설명, 라벨 등에 사용
    static func caption() -> Font {
        .system(size: 12)
    }
    
    /// 소형 폰트 (SF Pro, 11pt, Regular)
    /// - 메뉴 바 아이콘 아래 텍스트, 최소 크기 라벨 등에 사용
    static func small() -> Font {
        .system(size: 11)
    }
}
