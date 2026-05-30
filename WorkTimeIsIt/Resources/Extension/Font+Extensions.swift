//
//  Font+Extensions.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

// MARK: - Font 확장
/// AppFonts에 정의된 폰트를 더 편리하게 사용할 수 있는 확장입니다.
/// `Font.appTimer` 형태로 접근할 수 있습니다.
extension Font {
    
    /// 타이머 표시용 모노스페이스 폰트 (40pt, Bold)
    static var appTimer: Font {
        AppFonts.timer()
    }
    
    /// 제목용 폰트 (16pt, Semibold)
    static var appTitle: Font {
        AppFonts.title()
    }
    
    /// 본문용 폰트 (13pt, Regular)
    static var appBody: Font {
        AppFonts.body()
    }
    
    /// 캡션용 폰트 (11pt, Regular)
    static var appCaption: Font {
        AppFonts.caption()
    }
    
    /// 소형 폰트 (10pt, Regular)
    static var appSmall: Font {
        AppFonts.small()
    }
}

// MARK: - 모노스페이스 유틸리티
extension Font {
    
    /// 지정된 크기의 모노스페이스 폰트를 생성합니다.
    /// 숫자 표시에서 자릿수가 바뀌어도 레이아웃이 흔들리지 않습니다.
    /// - Parameters:
    ///   - size: 폰트 크기
    ///   - weight: 폰트 굵기 (기본값: .regular)
    /// - Returns: 모노스페이스 디자인의 시스템 폰트
    static func monospacedDigit(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
}
