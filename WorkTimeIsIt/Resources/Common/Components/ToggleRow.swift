//
//  ToggleRow.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

/// A row with a label on the left and a Toggle on the right.
/// Optionally displays a description text below the label in a smaller, secondary font.
struct ToggleRow: View {
    let label: String
    var description: String? = nil
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(label)
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.primaryText)

                if let description = description {
                    Text(description)
                        .font(AppFonts.small())
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
            }
        }
        .toggleStyle(.switch)
        .tint(AppColors.accent)
        .padding(.vertical, AppSpacing.xs)
    }
}

#Preview {
    VStack(spacing: 12) {
        ToggleRow(
            label: "야근 모드",
            description: "야근 시 추가 근무 시간을 설정합니다",
            isOn: .constant(true)
        )
        ToggleRow(
            label: "점심시간 제외",
            isOn: .constant(false)
        )
    }
    .padding()
    .frame(width: 280)
    .background(Color(red: 13/255, green: 17/255, blue: 23/255))
}
