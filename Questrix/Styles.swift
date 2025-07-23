//
//  Styles.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 23/07/25.
//


import SwiftUI

struct PremiumTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(AppFonts.body)
            .padding(16)
            .background(AppColors.cardBackground(for: colorScheme))
            .cornerRadius(AppShapes.mediumCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppShapes.mediumCornerRadius)
                    .stroke(AppColors.textSecondary(for: colorScheme).opacity(0.2), lineWidth: 1)
            )
            .accentColor(AppColors.primary)
            .shadow(color: AppColors.primary.opacity(0.05), radius: 2, x: 0, y: 2)
            .focusable(false)
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    var compact: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.headline)
            .foregroundColor(.white)
            .padding(.horizontal, compact ? 16 : 24)
            .padding(.vertical, compact ? 8 : 12)
            .frame(maxWidth: compact ? nil : .infinity)
            .background(AppColors.primary)
            .cornerRadius(AppShapes.mediumCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .shadow(color: AppColors.primary.opacity(0.3), radius: configuration.isPressed ? 4 : 8, x: 0, y: configuration.isPressed ? 2 : 4)
            .focusable(false)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var compact: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.headline)
            .foregroundColor(AppColors.primary)
            .padding(.horizontal, compact ? 16 : 24)
            .padding(.vertical, compact ? 8 : 12)
            .frame(maxWidth: compact ? nil : .infinity)
            .background(AppColors.primary.opacity(0.1))
            .cornerRadius(AppShapes.mediumCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppShapes.mediumCornerRadius)
                    .stroke(AppColors.primary, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .focusable(false)
    }
}

struct TextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.headline)
            .foregroundColor(AppColors.primary)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .underline(configuration.isPressed, color: AppColors.primary)
    }
}
