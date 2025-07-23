//
//  ContentOverview.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct StatsOverviewView: View {
    @EnvironmentObject var courseArray: CoursesArray
    @EnvironmentObject var quizArray: QuizArray
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(spacing: 16) {
            StatCard(
                icon: "book",
                value: "\(courseArray.courses.count)",
                title: "Courses",
                color: AppColors.primary
            )
            
            StatCard(
                icon: "questionmark.square",
                value: "\(quizArray.quizzes.count)",
                title: "Quizzes",
                color: AppColors.secondary
            )
            
            StatCard(
                icon: "checkmark.square",
                value: "\(ContentView.fileManager.getAttemptedQuizCount())",
                title: "Attempted",
                color: AppColors.accent
            )
        }
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.1))
                .cornerRadius(AppShapes.smallCornerRadius)
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.textPrimary(for: colorScheme))
            
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary(for: colorScheme))
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(AppShapes.mediumCornerRadius)
        .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
