//
//  TimeInputField.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

/// A time picker input field with a label above it.
/// Features a dark background with rounded corners, displaying formatted time like "09:00 AM".
struct TimeInputField: View {
    let label: String
    @Binding var selection: Date

    @State private var isHovering = false

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: selection)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(label)
                .font(AppFonts.caption())
                .foregroundColor(AppColors.secondaryText)

            HStack {
                Image(systemName: "clock")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.secondaryText)

                DatePicker(
                    "",
                    selection: $selection,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                .datePickerStyle(.field)
                .colorScheme(.dark)

                Spacer()
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                    .fill(AppColors.inputBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                            .stroke(
                                isHovering ? AppColors.accent.opacity(0.3) : Color.clear,
                                lineWidth: 1
                            )
                    )
            )
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovering = hovering
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        TimeInputField(
            label: "출근시간(근무시작시간)",
            selection: .constant(Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date())
        )
        TimeInputField(
            label: "퇴근시간(근무종료시간)",
            selection: .constant(Calendar.current.date(from: DateComponents(hour: 18, minute: 0)) ?? Date())
        )
    }
    .padding()
    .frame(width: 280)
    .background(Color(red: 13/255, green: 17/255, blue: 23/255))
}
