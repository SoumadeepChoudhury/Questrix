//
//  EmptyStateView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/07/25.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: icon)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(AppColors.accent)
            }
            
            // Text Content
            VStack(spacing: 8) {
                Text(title)
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))
                
                Text(message)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
            }
            
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        
        .cornerRadius(AppShapes.largeCornerRadius)
        .shadow(color: AppColors.primary.opacity(0.05), radius: 16, x: 0, y: 8)
    }
}
