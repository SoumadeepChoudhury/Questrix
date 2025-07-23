//
//  ChartView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI
import Charts

//struct ChartView: View {
//    @EnvironmentObject var USER: User
//    
//    var body: some View {
//        GroupBox{
//            HStack{
//                VStack(alignment: .leading){
//                    Text("Your Activity").font(.title).fontWeight(.semibold)
//                    Text("Last 7 using days.").font(.caption2)
//                }
//                Spacer()
//            }
//            
//            //Chart -> Foreach -> LineMark -> AreaMark
//            Chart(USER.activityData.reversed()) {item in
//                LineMark(x: .value("Date",item.type), y: .value("Number of Quizes",item.value))
//                    .interpolationMethod(.catmullRom)
//                
//                AreaMark(x: .value("Date",item.type), y: .value("Number of Quizes",item.value))
//                    .opacity(0.1)
//                    .interpolationMethod(.catmullRom)
//            }.chartYScale(domain: 0...(USER.MaxActivityYScale + .random(in: 1...5)))
//        }.frame(maxHeight:250)
//    }
//}

struct ActivityChartView: View {
    @EnvironmentObject var user: User
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your Activity")
                    .font(AppFonts.title2)
                
                Spacer()
                
                Text("Last 7 days")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
            }
            
            Chart(user.activityData.reversed()) { item in
                AreaMark(
                    x: .value("Day", item.type),
                    y: .value("Quizzes", item.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.accent.opacity(0.3), AppColors.accent.opacity(0.01)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                LineMark(
                    x: .value("Day", item.type),
                    y: .value("Quizzes", item.value)
                )
                .foregroundStyle(AppColors.accent)
                .interpolationMethod(.catmullRom)
                .symbol {
                    Circle()
                        .fill(AppColors.accent)
                        .frame(width: 8)
                        .shadow(color: AppColors.accent, radius: 3)
                }
            }
            .chartYScale(domain: 0...(user.MaxActivityYScale + 5))
            .frame(height: 200)
        }
        .padding(16)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(AppShapes.mediumCornerRadius)
    }
}
