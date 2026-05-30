//
//  PrimaryButton.swift
//  WorkTimeIsIt
//
//  Created by 나현흠 on 5/29/26.
//

import SwiftUI

/// A full-width purple accent button used for primary actions like
/// "Clock Out", "Save Changes", "시간 설정하기", etc.
struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    @State private var isHovering = false
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            HStack(spacing: AppSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(AppFonts.body())
                }
                Text(title)
                    .font(AppFonts.body())
                    .fontWeight(.semibold)
            }
            .foregroundColor(AppColors.primaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusSmall)
                    .fill(AppColors.accent)
                    .brightness(isHovering ? 0.08 : 0)
                    .brightness(isPressed ? -0.05 : 0)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isHovering)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "💾 시간 설정하기") {
            print("Save tapped")
        }
        PrimaryButton(title: "Save Changes", icon: "square.and.arrow.down") {
            print("Save tapped")
        }
    }
    .padding()
    .frame(width: 280)
    .background(Color(red: 13/255, green: 17/255, blue: 23/255))
}
