//
//  Theme.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/07/25.
//

import SwiftUI

enum AppColors {
    // Primary Colors
    static let primary = Color(red: 0.20, green: 0.50, blue: 0.80) // #3385CC
    static let primaryLight = Color(red: 0.40, green: 0.70, blue: 1.00) // #66B3FF
    static let primaryDark = Color(red: 0.10, green: 0.30, blue: 0.60) // #1A4D99
    
    // Secondary Colors
    static let secondary = Color(red: 0.90, green: 0.40, blue: 0.20) // #E66633
    static let secondaryLight = Color(red: 1.00, green: 0.60, blue: 0.40) // #FF9966
    static let secondaryDark = Color(red: 0.70, green: 0.20, blue: 0.00) // #B23300
    
    // Accent Colors
    static let accent = Color(red: 0.38, green: 0.81, blue: 0.83) // #61CFD4
    static let accentLight = Color(red: 0.60, green: 0.95, blue: 0.97) // #99F2F7
    static let accentDark = Color(red: 0.15, green: 0.65, blue: 0.68) // #26A6AD
    
    // Background Colors
    static let background = Color(red: 0.95, green: 0.96, blue: 0.98) // #F2F5FA (Light)
    static let backgroundDark = Color(red: 0.10, green: 0.11, blue: 0.13) // #191C21 (Dark)
    
    // Card Colors
    static let cardBackground = Color.white // #FFFFFF (Light)
    static let cardBackgroundDark = Color(red: 0.15, green: 0.16, blue: 0.18) // #262A2E (Dark)
    
    // Text Colors
    static let textPrimary = Color(red: 0.10, green: 0.10, blue: 0.10) // #1A1A1A (Light)
    static let textPrimaryDark = Color.white // #FFFFFF (Dark)
    static let textSecondary = Color(red: 0.40, green: 0.40, blue: 0.40) // #666666 (Light)
    static let textSecondaryDark = Color(red: 0.70, green: 0.70, blue: 0.70) // #B3B3B3 (Dark)
    
    // Status Colors
    static let success = Color(red: 0.20, green: 0.80, blue: 0.40) // #33CC66
    static let warning = Color(red: 1.00, green: 0.80, blue: 0.20) // #FFCC33
    static let error = Color(red: 0.90, green: 0.20, blue: 0.20) // #E63333
    
    // Gradients
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [primary, primaryLight]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        gradient: Gradient(colors: [accent, accentLight]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Dynamic colors that adapt to color scheme
    static func background(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? backgroundDark : background
    }
    
    static func cardBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? cardBackgroundDark : cardBackground
    }
    
    static func textPrimary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? textPrimaryDark : textPrimary
    }
    
    static func textSecondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? textSecondaryDark : textSecondary
    }
}

enum AppFonts {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title = Font.system(size: 28, weight: .semibold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .medium, design: .rounded)
    static let body = Font.system(size: 17, weight: .regular, design: .rounded)
    static let caption = Font.system(size: 13, weight: .regular, design: .rounded)
}

enum AppShapes {
    static let smallCornerRadius: CGFloat = 8
    static let mediumCornerRadius: CGFloat = 12
    static let largeCornerRadius: CGFloat = 16
}

struct AppShadow {
    static let small = AnyViewModifier { view in
        view.shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2) as! AnyView
    }
    
    static let medium = AnyViewModifier { view in
        view.shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4) as! AnyView
    }
    
    static let large = AnyViewModifier { view in
        view.shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6) as! AnyView
    }
}

// Helper ViewModifier
struct AnyViewModifier: ViewModifier {
    let modify: (AnyView) -> AnyView

    func body(content: Content) -> some View {
        modify(AnyView(content))
    }
}

