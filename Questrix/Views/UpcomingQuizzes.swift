//
//  UpcomingQuizzes.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 19/09/24.
//

import SwiftUI

struct UpcomingQuizzes: View {
    @EnvironmentObject var quizArray: QuizArray
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    
    
    var filteredQuizzes: [QuizData] {
        let availableQuizzes = quizArray.quizzes.filter {
            $0.releaseDate <= Date() && !$0.isDrafted
        }
        
        if searchText.isEmpty {
            return availableQuizzes
        } else {
            return availableQuizzes.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.course.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with search
            UpcomingTitle(searchText: $searchText)
                .padding(.horizontal)
                .padding(.top, 12)
                .background(AppColors.cardBackground(for: colorScheme))
                .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
            
            // Content
            if filteredQuizzes.isEmpty {
                if quizArray.quizzes.isEmpty {
                    EmptyStateView(
                        icon: "calendar.badge.clock",
                        title: "No Quizzes Available",
                        message: "Create quizzes to see them listed here."
                    )
                } else {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "No Matching Quizzes",
                        message: "Try adjusting your search to find what you're looking for."
                    )
                }
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 300), spacing: 20)],
                        spacing: 20
                    ) {
                        ForEach(filteredQuizzes) { quiz in
                            QuizCard(
                                quiz: quiz,
                                actionType: quiz.isAttempted ? .reAttempt : .start
                            )
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .background(AppColors.background(for: colorScheme))
        .navigationTitle("Upcoming Quizzes")
    }
}

#Preview {
    UpcomingQuizzes()
        .environmentObject(QuizArray.sampleData)
        .frame(width: 800, height: 600)
}
