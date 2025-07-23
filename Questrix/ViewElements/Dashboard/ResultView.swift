//
//  TableView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct RecentResultsView: View {
    @EnvironmentObject var user: User
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Results")
                    .font(AppFonts.title2)
                
                Spacer()
                
                Text("Last 10 attempts")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
            }
            
            if user.resultData.isEmpty {
                EmptyStateView(
                    icon: "book",
                    title: "No Quiz Attempted",
                    message: "Attempt your first quiz to see your results here."
                )
                .padding(.horizontal, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(user.resultData.prefix(5)) { result in
                            ResultCard(result: result)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(AppShapes.mediumCornerRadius)
    }
}

struct ResultCard: View {
    let result: ResultData
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(result.title)
                    .font(AppFonts.headline)
                    .lineLimit(1)
                
                Spacer()
                
                Text("\(result.pointsAcquired)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.accent)
            }
            
            Text(result.date)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary(for: colorScheme))
            
            ProgressView(value: Double(result.pointsAcquired ?? 0), total: Double(result.totalPoints) ?? 100)
                .tint(AppColors.accent)
            
            HStack {
                Text("\(result.pointsAcquired)/\(result.totalPoints) points")
                    .font(AppFonts.caption)
                
                Spacer()
                
                Text("\(Int((Double(result.pointsAcquired) ?? 0) / (Double(result.totalPoints) ?? 1)*100))%")
                    .font(AppFonts.caption)
                    .bold()
            }
        }
        .padding(16)
        .frame(width: 220)
        .background(AppColors.background(for: colorScheme))
        .cornerRadius(AppShapes.mediumCornerRadius)
    }
}


