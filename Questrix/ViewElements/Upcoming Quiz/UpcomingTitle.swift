//
//  UpcomingTitle.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 22/09/24.
//
import SwiftUI

struct UpcomingTitle: View {
    @Binding var searchText: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Upcoming Quizzes")
                    .font(AppFonts.largeTitle)
                
                Text("Available quizzes ready to attempt")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
            }
            
            Spacer()
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
                
                TextField("Search quizzes...", text: $searchText)
                    .textFieldStyle(.plain)
                    .submitLabel(.search)
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))
                    .tint(AppColors.primary)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(AppColors.cardBackground(for: colorScheme))
            .cornerRadius(AppShapes.mediumCornerRadius)
            .frame(width: 250)
        }
        .padding(.vertical, 12)
    }
}


// MARK: - Preview Extension
extension QuizArray {
    static var sampleData: QuizArray {
        let array = QuizArray()
        array.quizzes = [
            QuizData(
                course: "Mathematics",
                title: "Algebra Fundamentals",
                description: "",
                duration: 30,
                releaseDate: Date(),
                questionsData: [],
                isAttempted: false,
                isDrafted: false
            ),
            QuizData(
                course: "Science",
                title: "Physics Basics",
                description: "",
                duration: 45,
                releaseDate: Date(),
                questionsData: [],
                isAttempted: true,
                isDrafted: false
            )
        ]
        return array
    }
}
