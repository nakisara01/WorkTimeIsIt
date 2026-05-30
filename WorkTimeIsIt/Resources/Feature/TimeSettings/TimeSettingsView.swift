//
//  TimeSettingsView.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

/// The time settings screen where users configure work hours,
/// overtime, and lunch break settings.
struct TimeSettingsView: View {
    @State private var viewModel: TimeSettingsViewModel

    init(navigate: @escaping (NavigationDestination) -> Void) {
        _viewModel = State(initialValue: TimeSettingsViewModel(navigate: navigate))
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            headerSection

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: AppSpacing.lg) {
                    // MARK: - Info Banner
                    infoBanner

                    // MARK: - Work Hours Section
                    workHoursSection

                    // MARK: - Overtime Section
                    overtimeSection

                    // MARK: - Lunch Break Section
                    lunchBreakSection

                    // MARK: - Save Button
                    saveButton

                    // MARK: - Footer
                    footerText
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
            }
        }
        .frame(width: 320)
        .background(AppColors.background)
    }

    // MARK: - Header

    private var headerSection: some View {
        ZStack {
            // Title centered
            Text("시간 설정")
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
                        Text("돌아가기")
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

    // MARK: - Info Banner

    private var infoBanner: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            Image(systemName: "info.circle.fill")
                .font(AppFonts.caption())
                .foregroundColor(AppColors.accent)

            Text("근무 시간을 설정하면 퇴근까지 남은 시간을 정확하게 계산할 수 있습니다.")
                .font(AppFonts.small())
                .foregroundColor(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                .fill(AppColors.accent.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                        .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                )
        )
    }

    // MARK: - Work Hours Section

    private var workHoursSection: some View {
        VStack(spacing: AppSpacing.md) {
            TimeInputField(
                label: "출근시간 (근무시작시간)",
                selection: $viewModel.startTime
            )

            // 총 업무시간 입력
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("총 업무시간")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.secondaryText)

                HStack {
                    Image(systemName: "timer")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.secondaryText)

                    Text(viewModel.totalWorkHoursString)
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.primaryText)
                        .monospacedDigit()

                    Spacer()

                    Stepper(
                        "",
                        value: $viewModel.totalWorkHours,
                        in: 1.0...16.0,
                        step: 0.5
                    )
                    .labelsHidden()
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                        .fill(AppColors.inputBackground)
                )
            }

            // 퇴근 예정 시간 (자동 계산, 읽기 전용)
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("퇴근 예정 시간 (자동 계산)")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.secondaryText)

                HStack {
                    Image(systemName: "arrow.left.circle")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.accent)

                    Text(viewModel.formattedEndTime)
                        .font(.system(size: 17, weight: .bold, design: .monospaced))
                        .foregroundColor(AppColors.accent)

                    Spacer()
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                        .fill(AppColors.accent.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                                .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                        )
                )
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.cardBackground)
        )
    }

    // MARK: - Overtime Section

    private var overtimeSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Section title
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "moon.fill")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.accent)
                Text("야근 설정")
                    .font(AppFonts.body())
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryText)
            }

            ToggleRow(
                label: "야근 모드 활성화",
                description: "야근 시 추가 근무 시간을 설정합니다",
                isOn: $viewModel.overtimeEnabled
            )

            if viewModel.overtimeEnabled {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("추가 근무 시간")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.secondaryText)

                    HStack {
                        Text("\(viewModel.overtimeHours, specifier: "%.1f") 시간")
                            .font(AppFonts.body())
                            .foregroundColor(AppColors.primaryText)
                            .monospacedDigit()

                        Spacer()

                        Stepper(
                            "",
                            value: $viewModel.overtimeHours,
                            in: 0.5...8.0,
                            step: 0.5
                        )
                        .labelsHidden()
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                            .fill(AppColors.inputBackground)
                    )
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.cardBackground)
        )
        .animation(.easeInOut(duration: 0.25), value: viewModel.overtimeEnabled)
    }

    // MARK: - Lunch Break Section

    private var lunchBreakSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Section title
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "fork.knife")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.accent)
                Text("점심시간 설정")
                    .font(AppFonts.body())
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryText)
            }

            ToggleRow(
                label: "점심시간 제외",
                description: "근무 시간에서 점심시간을 제외합니다",
                isOn: $viewModel.lunchBreakEnabled
            )

            if viewModel.lunchBreakEnabled {
                VStack(spacing: AppSpacing.md) {
                    TimeInputField(
                        label: "점심시간 시작",
                        selection: $viewModel.lunchStartTime
                    )

                    TimeInputField(
                        label: "점심시간 종료",
                        selection: $viewModel.lunchEndTime
                    )
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.cardBackground)
        )
        .animation(.easeInOut(duration: 0.25), value: viewModel.lunchBreakEnabled)
    }

    // MARK: - Save Button

    private var saveButton: some View {
        VStack(spacing: AppSpacing.sm) {
            PrimaryButton(title: "💾 시간 설정하기") {
                viewModel.save()
            }

            if viewModel.isSaved {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("설정이 저장되었습니다!")
                        .font(AppFonts.small())
                        .foregroundColor(.green)
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isSaved)
    }

    // MARK: - Footer

    private var footerText: some View {
        Text("설정한 시간은 자동으로 메뉴바에 반영됩니다.\n언제든지 변경할 수 있습니다.")
            .font(AppFonts.small())
            .foregroundColor(AppColors.secondaryText)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.bottom, AppSpacing.sm)
    }
}

#Preview {
    TimeSettingsView(navigate: { _ in })
        .frame(height: 600)
}
