//
//  SettingsRow.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

/// A horizontal row with a label on the left and a value or custom content on the right.
/// Used throughout settings screens for displaying key-value pairs or navigation items.
struct SettingsRow<Content: View>: View {
    let label: String
    var value: String? = nil
    var showChevron: Bool = false
    @ViewBuilder var content: () -> Content

    var body: some View {
        HStack {
            Text(label)
                .font(AppFonts.body())
                .foregroundColor(AppColors.secondaryText)

            Spacer()

            if let value = value {
                Text(value)
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.primaryText)
            }

            content()

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.vertical, AppSpacing.sm)
    }
}

/// Convenience initializer when only showing a value string (no custom content).
extension SettingsRow where Content == EmptyView {
    init(label: String, value: String? = nil, showChevron: Bool = false) {
        self.label = label
        self.value = value
        self.showChevron = showChevron
        self.content = { EmptyView() }
    }
}

#Preview {
    VStack(spacing: 0) {
        SettingsRow(label: "Display Mode", value: "남은 시간")
        SettingsRow(label: "Theme", value: "Dark", showChevron: true)
        SettingsRow(label: "Custom") {
            Circle()
                .fill(Color.purple)
                .frame(width: 20, height: 20)
        }
    }
    .padding()
    .frame(width: 280)
    .background(Color(red: 13/255, green: 17/255, blue: 23/255))
}
