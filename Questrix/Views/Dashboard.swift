//
//  Dashboard.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 19/09/24.
//

import SwiftUI
import Charts

struct Dashboard: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var courseArray: CoursesArray
    @EnvironmentObject var quizArray: QuizArray
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dashboard")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.textPrimary(for: colorScheme))
                        
                        Text("Welcome back, \(user.UserName)!")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    DateTime().padding(.leading,4)
                }
                
                // Stats Overview
                StatsOverviewView()
                    .padding(.vertical, 8)
                
                // Activity Chart
                ActivityChartView()
                    .frame(height: 300)
                
                // Recent Results
                RecentResultsView()
            }
            .padding(20)
        }
        .background(AppColors.background(for: colorScheme))
    }
}




