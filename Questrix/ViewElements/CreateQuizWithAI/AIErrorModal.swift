//
//  AIErrorModal.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 23/07/25.
//

import SwiftUI

struct AIErrorModal: View {
    @Binding var isPresented: Bool
    let errorMessage: String
    var retryAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { isPresented = false }
            
            // Modal content
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(AppColors.error)
                    
                    Text("Generation Failed")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                }
                
                // Error message
                Text(errorMessage)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
                
                // Action buttons
                HStack(spacing: 16) {
                    if let retryAction = retryAction {
                        Button(action: {
                            isPresented = false
                            retryAction()
                        }) {
                            Text("Try Again")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    
                    Button(action: { isPresented = false }) {
                        Text(retryAction == nil ? "OK" : "Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .padding(.top, 8)
            }
            .padding(24)
            .frame(width: 320)
            .background(AppColors.cardBackground)
            .cornerRadius(AppShapes.largeCornerRadius)
            .shadow(color: AppColors.error.opacity(0.2), radius: 20, x: 0, y: 10)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .zIndex(100)
    }
}

