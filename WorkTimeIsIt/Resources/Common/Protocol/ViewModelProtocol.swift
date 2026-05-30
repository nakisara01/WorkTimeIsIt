//
//  ViewModelProtocol.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import Foundation
import Combine

// MARK: - ViewModel 프로토콜
/// 모든 ViewModel이 준수해야 하는 기본 프로토콜입니다.
/// MVVM 아키텍처에서 View와 Model 사이의 일관된 인터페이스를 보장합니다.
///
/// 사용 예시:
/// ```swift
/// @MainActor
/// final class DashboardViewModel: ViewModelProtocol {
///     func onAppear() { /* 초기 데이터 로드 */ }
///     func onDisappear() { /* 리소스 정리 */ }
/// }
/// ```
@MainActor
protocol ViewModelProtocol: ObservableObject {
    
    /// View가 나타날 때 호출됩니다.
    /// 데이터 로딩, 타이머 시작 등 초기화 작업을 수행합니다.
    func onAppear()
    
    /// View가 사라질 때 호출됩니다.
    /// 타이머 중지, 구독 해제 등 정리 작업을 수행합니다.
    func onDisappear()
}

// MARK: - 기본 구현
/// onAppear, onDisappear의 기본 구현을 제공하여 선택적으로 오버라이드할 수 있습니다.
extension ViewModelProtocol {
    func onAppear() {}
    func onDisappear() {}
}
