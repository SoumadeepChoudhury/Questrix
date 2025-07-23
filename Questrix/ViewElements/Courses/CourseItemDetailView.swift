//
//  CourseItemDetailView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct CourseItemDetailView: View {
    @EnvironmentObject var quizArray: QuizArray
    
    
    let courseTitle: String
    @Binding var selectedTab: String
    var _dismiss: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var filteredQuizzes: [QuizData] {
        quizArray.quizzes.filter { $0.course == courseTitle }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
        
            HStack {
                VStack(alignment: .leading){
                    Button(action: { _dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Back to Courses")
                        }
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primary)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom,4)
                    
                    Text(courseTitle)
                        .font(AppFonts.title)
                        .lineLimit(1)
                    
                }
                .padding()
                Spacer()
            }
            
            
            
            // Content
            if filteredQuizzes.isEmpty {
                EmptyStateView(
                    icon: "questionmark.folder",
                    title: "No Quizzes Yet",
                    message: "Create your first quiz for this course to get started."
                )
                .padding(.top, 40)
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 300), spacing: 20)],
                        spacing: 20
                    ) {
                        ForEach(filteredQuizzes) { quiz in
                            QuizCard(
                                quiz: quiz,
                                actionType: quiz.isAttempted ? .review : .start
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .background(AppColors.background(for: colorScheme))
        .navigationTitle(courseTitle)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Quiz Card Component
struct QuizCard: View {
    @EnvironmentObject var startQuiz: StartQuiz
    @Environment(\.openWindow) var openWindow
    @Environment(\.colorScheme) var colorScheme
    
    let quiz: QuizData
    let actionType: QuizActionType
    @State private var showDeleteConfirmation: Bool = false
    
    @State private var isActionSucessful: Bool = false
    
    enum QuizActionType {
        case start, reAttempt, review
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .top) {
                Image(systemName: "clock.badge.checkmark")
                    .font(.title2)
                    .foregroundColor(AppColors.accent)
                    .frame(width: 44, height: 44)
                    .background(AppColors.accent.opacity(0.1))
                    .cornerRadius(AppShapes.smallCornerRadius)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(quiz.title)
                        .font(AppFonts.headline)
                        .lineLimit(2)
                    
                    Text(quiz.course)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                }
                
                Spacer()
                
                Image(systemName: "xmark")
                    .onTapGesture{
                        showDeleteConfirmation = true
                    }
                    .alert("Are you sure?",isPresented: $showDeleteConfirmation){
                        Button("Yes"){
                            //delete
                            ContentView.fileManager.deleteQuiz(course: quiz.course, title: quiz.title, isSubmitted: quiz.isAttempted)
                            isActionSucessful = true
                        }
                        Button("No"){
                            showDeleteConfirmation = false
                        }
                    }
                    .alert("\(quiz.title) Sucessfully deleted",isPresented: $isActionSucessful){
                        Button("Ok"){
                            isActionSucessful = false
                        }
                    }
            }
            
            // Details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    Text("\(quiz.questionsData.count) questions")
                        .font(AppFonts.caption)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    Text("\(quiz.duration) min duration")
                        .font(AppFonts.caption)
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    Text("Released \(quiz.releaseDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(AppFonts.caption)
                }
            }
            
            // Action Button
            Button(action: handleAction) {
                HStack {
                    Text(buttonTitle)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .font(AppFonts.headline)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background(buttonBackground)
                .foregroundColor(buttonForeground)
                .cornerRadius(AppShapes.smallCornerRadius)
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(AppShapes.mediumCornerRadius)
        .shadow(color: AppColors.primary.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var buttonTitle: String {
        switch actionType {
        case .start: return "Start Quiz"
        case .reAttempt: return "Re-Attempt"
        case .review: return "Review"
        }
    }
    
    private var buttonBackground: some View {
        switch actionType {
        case .start: return AppColors.primary.opacity(0.1)
        case .reAttempt: return AppColors.accent.opacity(0.1)
        case .review: return AppColors.secondary.opacity(0.1)
        }
    }
    
    private var buttonForeground: Color {
        switch actionType {
        case .start: return AppColors.primary
        case .reAttempt: return AppColors.accent
        case .review: return AppColors.secondary
        }
    }
    
    private func handleAction() {
        startQuiz.course = quiz.course
        startQuiz.title = quiz.title
        
        switch actionType {
        case .start:
            startQuiz.isReAttempt = false
            startQuiz.isReview = false
        case .reAttempt:
            startQuiz.isReAttempt = true
            startQuiz.isReview = false
        case .review:
            startQuiz.isReAttempt = false
            startQuiz.isReview = true
        }
        
        openWindow(id: "PractisePage")
    }
}
