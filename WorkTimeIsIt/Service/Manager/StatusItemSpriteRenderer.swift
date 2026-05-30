//
//  StatusItemSpriteRenderer.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import AppKit

// MARK: - Sprite Sheet 렌더러
/// 5×5 그리드 sprite sheet 이미지를 25개 프레임으로 슬라이스하고,
/// beat(프레임 인덱스)에 따라 해당 프레임을 반환합니다.
/// 메뉴바 아이콘 애니메이션과 환경설정 미리보기에서 사용됩니다.
@MainActor
final class StatusItemSpriteRenderer {

    // MARK: - Sheet 레이아웃

    /// Sprite sheet의 그리드 레이아웃 정보
    private struct SheetSpec {
        let assetName: String
        let columns: Int
        let rows: Int
    }

    // MARK: - 상수

    private enum Constants {
        /// 모든 sprite sheet는 4×4 그리드
        static let gridColumns = 4
        static let gridRows = 4

        /// 메뉴바 아이콘 목표 크기
        static let targetIconSize = NSSize(width: 18, height: 18)

        /// 사용 가능한 sprite 목록 (인덱스 순서)
        static let sprites: [SheetSpec] = [
            SheetSpec(assetName: "minor_sprite", columns: gridColumns, rows: gridRows),
            SheetSpec(assetName: "runner_sprite", columns: gridColumns, rows: gridRows),
            SheetSpec(assetName: "rocket_sprite", columns: gridColumns, rows: gridRows),
            SheetSpec(assetName: "surfer_sprite", columns: gridColumns, rows: gridRows)
        ]
    }

    // MARK: - 캐시

    /// 에셋 이름별로 슬라이스된 프레임 배열을 캐싱
    private var cachedFrames: [String: [NSImage]] = [:]

    // MARK: - 공개 메서드

    /// 선택된 스프라이트의 총 프레임 수를 반환합니다.
    var totalFrameCount: Int {
        Constants.gridColumns * Constants.gridRows
    }

    /// 선택된 sprite의 특정 beat(프레임)에 해당하는 이미지를 반환합니다.
    /// - Parameters:
    ///   - spriteIndex: 스프라이트 인덱스 (0-3, UserDefaults의 selectedSpriteIndex)
    ///   - beat: 애니메이션 프레임 인덱스 (0부터 순환)
    /// - Returns: 해당 프레임의 NSImage (실패 시 nil)
    func frame(forSpriteIndex spriteIndex: Int, beat: Int) -> NSImage? {
        guard spriteIndex >= 0, spriteIndex < Constants.sprites.count else { return nil }

        let spec = Constants.sprites[spriteIndex]
        guard let frames = frames(for: spec), !frames.isEmpty else { return nil }
        return frames[beat % frames.count]
    }

    /// 선택된 sprite의 첫 번째 프레임을 반환합니다 (정지 상태용).
    /// - Parameter spriteIndex: 스프라이트 인덱스 (0-3)
    /// - Returns: 첫 번째 프레임의 NSImage (실패 시 nil)
    func firstFrame(forSpriteIndex spriteIndex: Int) -> NSImage? {
        return frame(forSpriteIndex: spriteIndex, beat: 0)
    }

    /// 특정 크기의 프레임을 반환합니다 (환경설정 미리보기용).
    /// - Parameters:
    ///   - spriteIndex: 스프라이트 인덱스 (0-3)
    ///   - beat: 애니메이션 프레임 인덱스
    ///   - size: 원하는 출력 크기
    /// - Returns: 지정 크기의 NSImage (실패 시 nil)
    func frame(forSpriteIndex spriteIndex: Int, beat: Int, targetSize size: NSSize) -> NSImage? {
        guard spriteIndex >= 0, spriteIndex < Constants.sprites.count else { return nil }

        let spec = Constants.sprites[spriteIndex]

        // 캐시 키에 크기 정보 포함
        let cacheKey = "\(spec.assetName)_\(Int(size.width))x\(Int(size.height))"

        if let cached = cachedFrames[cacheKey], !cached.isEmpty {
            return cached[beat % cached.count]
        }

        // 원본 CGImage에서 슬라이스 후 지정 크기로 변환
        guard let image = NSImage(named: spec.assetName),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        else { return nil }

        let frames = sliceGridFrames(from: cgImage, spec: spec, targetSize: size)
        guard !frames.isEmpty else { return nil }
        cachedFrames[cacheKey] = frames
        return frames[beat % frames.count]
    }

    // MARK: - 내부 메서드

    /// 지정된 SheetSpec에 해당하는 프레임 배열을 가져옵니다 (캐시 우선).
    private func frames(for spec: SheetSpec) -> [NSImage]? {
        if let cached = cachedFrames[spec.assetName] {
            return cached
        }

        guard let image = NSImage(named: spec.assetName),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        else { return nil }

        let frames = sliceGridFrames(
            from: cgImage,
            spec: spec,
            targetSize: Constants.targetIconSize
        )
        guard !frames.isEmpty else { return nil }
        cachedFrames[spec.assetName] = frames
        return frames
    }

    /// 5×5 그리드 sprite sheet에서 좌→우, 상→하 순서로 프레임을 추출합니다.
    /// - Parameters:
    ///   - source: 원본 CGImage (전체 sprite sheet)
    ///   - spec: 그리드 레이아웃 정보
    ///   - targetSize: 각 프레임의 출력 크기
    /// - Returns: 슬라이스된 프레임 NSImage 배열
    private func sliceGridFrames(
        from source: CGImage,
        spec: SheetSpec,
        targetSize: NSSize
    ) -> [NSImage] {
        let columns = spec.columns
        let rows = spec.rows
        guard columns > 0, rows > 0 else { return [] }

        var result: [NSImage] = []
        result.reserveCapacity(columns * rows)

        for row in 0..<rows {
            for column in 0..<columns {
                let xStart = Int(round(Double(column) * Double(source.width) / Double(columns)))
                let xEnd = Int(round(Double(column + 1) * Double(source.width) / Double(columns)))
                let yTop = Int(round(Double(row) * Double(source.height) / Double(rows)))
                let yBottom = Int(round(Double(row + 1) * Double(source.height) / Double(rows)))

                let frameWidth = max(1, xEnd - xStart)
                let frameHeight = max(1, yBottom - yTop)

                // CGImage의 좌표는 좌하단 원점이므로 y축 반전
                let y = source.height - yBottom
                let cropRect = CGRect(x: xStart, y: y, width: frameWidth, height: frameHeight)

                guard let frameCG = source.cropping(to: cropRect) else { continue }
                result.append(makeScaledImage(from: frameCG, targetSize: targetSize))
            }
        }

        return result
    }

    /// CGImage를 지정 크기로 스케일링하여 NSImage를 생성합니다.
    /// - Parameters:
    ///   - frameCG: 원본 프레임 CGImage
    ///   - targetSize: 출력 크기
    /// - Returns: 스케일링된 NSImage
    private func makeScaledImage(from frameCG: CGImage, targetSize: NSSize) -> NSImage {
        let sourceSize = NSSize(width: frameCG.width, height: frameCG.height)
        let scale = min(targetSize.width / sourceSize.width, targetSize.height / sourceSize.height)
        let drawSize = NSSize(width: sourceSize.width * scale, height: sourceSize.height * scale)
        let drawOrigin = NSPoint(
            x: (targetSize.width - drawSize.width) / 2,
            y: (targetSize.height - drawSize.height) / 2
        )

        let image = NSImage(size: targetSize)
        image.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        NSImage(cgImage: frameCG, size: sourceSize)
            .draw(in: NSRect(origin: drawOrigin, size: drawSize))
        image.unlockFocus()
        image.isTemplate = false
        return image
    }
}
