//
//  DashboardView.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

// MARK: - Design Tokens

private enum DashboardColors {
    static let background = Color(hex: "0D1117")
    static let card = Color(hex: "161B22")
    static let inputTrack = Color(hex: "21262D")
    static let accent = Color(hex: "7C6AED")
    static let primaryText = Color.white
    static let secondaryText = Color(hex: "8B949E")
    static let success = Color(hex: "3FB950")
    static let warning = Color(hex: "F0883E")
}

// MARK: - DashboardView

struct DashboardView: View {
    @Environment(TimeManager.self) private var timeManager
    let navigate: (NavigationDestination) -> Void

    init(navigate: @escaping (NavigationDestination) -> Void) {
        self.navigate = navigate
    }

    /// ViewModel은 TimeManager를 래핑하여 표시용 데이터를 제공합니다
    private var viewModel: DashboardViewModel {
        DashboardViewModel(timeManager: timeManager)
    }

    var body: some View {
        VStack(spacing: 0) {
            headerSection

            if timeManager.isCompleted {
                completedSection
            } else {
                timerSection
                infoCardsSection
                clockOutButton
            }

            footerSection
        }
        .frame(width: 320)
        .background(DashboardColors.background)
        .onAppear {
            timeManager.startTimer()
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        HStack {
            Text("Work Time Is It?")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(DashboardColors.primaryText)

            Spacer()

            Button {
                navigate(.preferences)
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(DashboardColors.secondaryText)
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Timer Section

    private var timerSection: some View {
        VStack(spacing: 10) {
            // Status label
            Text(viewModel.statusLabel)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(DashboardColors.secondaryText)

            // Large countdown timer
            Text(viewModel.remainingTimeString)
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .foregroundStyle(DashboardColors.primaryText)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: viewModel.remainingTimeString)

            // Progress bar
            progressBar

            // Start / End time labels
            HStack {
                Text(viewModel.formattedStartTime)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundStyle(DashboardColors.secondaryText)

                Spacer()

                Text(viewModel.formattedEndTime)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundStyle(DashboardColors.secondaryText)
            }
            .padding(.horizontal, 2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 2)
                    .fill(DashboardColors.inputTrack)
                    .frame(height: 4)

                // Fill
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [
                                DashboardColors.accent.opacity(0.8),
                                DashboardColors.accent
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: max(0, geometry.size.width * CGFloat(viewModel.progress)),
                        height: 4
                    )
                    .animation(.easeInOut(duration: 0.5), value: viewModel.progress)
            }
        }
        .frame(height: 4)
    }

    // MARK: - Info Cards Section (3 cards)

    private var infoCardsSection: some View {
        HStack(spacing: 6) {
            // 체크인 시간 카드
            infoCard(
                icon: "arrow.right.circle",
                title: "체크인",
                value: viewModel.formattedStartTime,
                accentColor: DashboardColors.accent
            )

            // 점심 시간 카드
            infoCard(
                icon: "fork.knife",
                title: "점심",
                value: viewModel.formattedLunchTime,
                accentColor: DashboardColors.warning
            )

            // 퇴근 예정 카드
            infoCard(
                icon: "arrow.left.circle",
                title: "퇴근",
                value: viewModel.formattedEndTime,
                accentColor: DashboardColors.success
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private func infoCard(icon: String, title: String, value: String, accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(accentColor)

                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(DashboardColors.secondaryText)
            }

            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(DashboardColors.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(DashboardColors.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.04), lineWidth: 0.5)
        )
    }

    // MARK: - Clock Out Button

    private var clockOutButton: some View {
        Button {
            viewModel.clockOut()
        } label: {
            Text("🎵 Clock Out")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(DashboardColors.accent)
                        .shadow(
                            color: DashboardColors.accent.opacity(0.3),
                            radius: 8,
                            y: 2
                        )
                )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 8)
    }

    // MARK: - Completed Section

    private var completedSection: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 20)

            Text("🎉")
                .font(.system(size: 52))

            VStack(spacing: 4) {
                Text("수고하셨습니다!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(DashboardColors.primaryText)

                Text("오늘도 좋은 하루 되세요")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(DashboardColors.secondaryText)
            }

            // 업무 요약
            VStack(spacing: 8) {
                summaryRow(icon: "arrow.right.circle", label: "체크인", value: viewModel.formattedStartTime)
                summaryRow(icon: "clock", label: "근무 시간", value: viewModel.workHoursString)
                summaryRow(icon: "arrow.left.circle", label: "퇴근", value: viewModel.formattedEndTime)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(DashboardColors.card)
            )

            Spacer()
                .frame(height: 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private func summaryRow(icon: String, label: String, value: String) -> some View {
        HStack {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(DashboardColors.accent)
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(DashboardColors.secondaryText)
            }

            Spacer()

            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundStyle(DashboardColors.primaryText)
        }
    }

    // MARK: - Footer Section

    private var footerSection: some View {
        HStack {
            Button {
                navigate(.timeSettings)
            } label: {
                Text("시간 설정")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(DashboardColors.accent)
            }
            .buttonStyle(.plain)

            Spacer()

            Text(viewModel.appVersion)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(DashboardColors.secondaryText)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }
}

// MARK: - Preview

#Preview {
    DashboardView(
        navigate: { destination in
            print("Navigate to: \(destination)")
        }
    )
    .environment(TimeManager())
}
