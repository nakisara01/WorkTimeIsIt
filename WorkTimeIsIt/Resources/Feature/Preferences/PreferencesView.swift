//
//  PreferencesView.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

/// The preferences screen where users configure display mode,
/// countdown style, and select a menu bar sprite icon.
struct PreferencesView: View {
    @State private var viewModel: PreferencesViewModel

    init(navigate: @escaping (NavigationDestination) -> Void) {
        _viewModel = State(initialValue: PreferencesViewModel(navigate: navigate))
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            headerSection

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: AppSpacing.lg) {
                    // MARK: - Display Mode Section
                    displayModeSection

                    // MARK: - Sprite Selection Section
                    spriteSelectionSection
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
            }
        }
        .frame(width: 320, height: 500)
        .background(AppColors.background)
    }

    // MARK: - Header

    private var headerSection: some View {
        ZStack {
            // Title centered
            Text(String(localized: "preferences.title"))
                .font(AppFonts.title())
                .foregroundColor(AppColors.primaryText)

            // Back button on leading edge
            HStack {
                Button(action: {
                    viewModel.goBack()
                }) {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "chevron.left")
                            .font(.caption)
                        Text(String(localized: "preferences.back"))
                            .font(AppFonts.caption())
                    }
                    .foregroundColor(AppColors.secondaryText)
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
    }

    // MARK: - Display Mode Section

    private var displayModeSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Section title
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "menubar.rectangle")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.accent)
                Text(String(localized: "preferences.displayMode.title"))
                    .font(AppFonts.body())
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryText)
            }


            // Visual indicator of current mode
            HStack {
                displayModeOption(
                    title: String(localized: "preferences.displayMode.remaining"),
                    example: "3h 24m",
                    icon: "timer",
                    isSelected: viewModel.displayMode == .remainingTime
                ) {
                    viewModel.setDisplayMode(.remainingTime)
                }

                displayModeOption(
                    title: String(localized: "preferences.displayMode.endTime"),
                    example: "06:00 PM",
                    icon: "clock",
                    isSelected: viewModel.displayMode == .endTime
                ) {
                    viewModel.setDisplayMode(.endTime)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.cardBackground)
        )
    }

    /// A selectable display mode option card.
    private func displayModeOption(
        title: String,
        example: String,
        icon: String,
        isSelected: Bool,
        onSelect: @escaping () -> Void
    ) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                onSelect()
            }
        }) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(AppFonts.body())
                    .foregroundColor(isSelected ? AppColors.accent : AppColors.secondaryText)

                Text(title)
                    .font(AppFonts.small())
                    .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)

                Text(example)
                    .font(AppFonts.small())
                    .foregroundColor(isSelected ? AppColors.accent : AppColors.secondaryText)
                    .monospacedDigit()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                    .fill(isSelected ? AppColors.accent.opacity(0.1) : AppColors.inputBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                            .stroke(
                                isSelected ? AppColors.accent.opacity(0.5) : Color.clear,
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }


    // MARK: - Sprite Selection Section

    private var spriteSelectionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Section title
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "person.fill")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.accent)
                Text(String(localized: "preferences.icon.title"))
                    .font(AppFonts.body())
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryText)
            }

            Text(String(localized: "preferences.icon.description"))
                .font(AppFonts.small())
                .foregroundColor(AppColors.secondaryText)

            // 2x2 Grid of sprite options with animated preview
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: AppSpacing.sm),
                    GridItem(.flexible(), spacing: AppSpacing.sm)
                ],
                spacing: AppSpacing.sm
            ) {
                ForEach(0..<viewModel.spriteOptions.count, id: \.self) { index in
                    AnimatedSpriteCard(
                        name: viewModel.spriteOptions[index].name,
                        spriteIndex: index,
                        isSelected: viewModel.selectedSpriteIndex == index,
                        onSelect: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.selectSprite(at: index)
                            }
                        }
                    )
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.cardBackground)
        )
    }

}

// MARK: - Animated Sprite Card

/// 환경설정에서 각 sprite를 애니메이션 미리보기와 함께 표시하는 카드 뷰.
/// 5×5 sprite sheet의 25프레임을 순환 재생합니다.
private struct AnimatedSpriteCard: View {
    let name: String
    let spriteIndex: Int
    let isSelected: Bool
    let onSelect: () -> Void

    /// 애니메이션 프레임 인덱스
    @State private var beat: Int = 0

    /// 현재 표시할 프레임 이미지
    @State private var currentFrame: NSImage?

    /// 애니메이션 타이머
    @State private var animationTimer: Timer?

    /// Sprite renderer (공유 인스턴스)
    @State private var renderer = StatusItemSpriteRenderer()

    /// 미리보기 애니메이션 속도
    private let fps: Double = 6.0

    /// 미리보기 프레임 크기
    private let previewSize = NSSize(width: 48, height: 48)

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: AppSpacing.sm) {
                // 애니메이션 sprite 미리보기
                Group {
                    if let frame = currentFrame {
                        Image(nsImage: frame)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    } else {
                        Rectangle()
                            .fill(AppColors.inputBackground)
                            .frame(width: 48, height: 48)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(name)
                    .font(AppFonts.small())
                    .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                    .fill(isSelected ? AppColors.accent.opacity(0.1) : AppColors.inputBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                            .stroke(
                                isSelected ? AppColors.accent : Color.clear,
                                lineWidth: isSelected ? 2 : 0
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }

    private func startAnimation() {
        updateFrame()
        let interval = 1.0 / fps
        animationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            Task { @MainActor in
                beat = (beat + 1) % renderer.totalFrameCount
                updateFrame()
            }
        }
    }

    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    private func updateFrame() {
        currentFrame = renderer.frame(
            forSpriteIndex: spriteIndex,
            beat: beat,
            targetSize: previewSize
        )
    }
}

#Preview {
    PreferencesView(navigate: { _ in })
        .frame(height: 550)
}
