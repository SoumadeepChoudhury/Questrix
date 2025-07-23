//
//  Courses.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 19/09/24.
//
import SwiftUI

struct Courses: View {
    @EnvironmentObject var COURSEARRAY: CoursesArray
    @Binding var selectedTab: String
    @State private var header: String = "Courses"
    @State private var isTapped: Bool = false
    @State private var courseTitle: String = ""
    @State private var showAddCourse = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(header)
                        .font(AppFonts.largeTitle)
                    
                    Text("See all the "+header.lowercased()+" here")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Spacer()
                
                // Add Course Button
                Button(action: { showAddCourse = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                        Text("Add Course")
                    }
                    .font(AppFonts.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppColors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(AppShapes.mediumCornerRadius)
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showAddCourse) {
                    AddCourseView( courseName: $courseTitle)
                        .presentationDetents([.medium])
                        .presentationCornerRadius(24)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
            
            // Main Content
            if !isTapped {
                if COURSEARRAY.courses.isEmpty {
                    // Empty State
                    EmptyStateView(
                        icon: "book.closed",
                        title: "No Courses Found",
                        message: "Create your first course to start organizing quizzes."
                    )
                    .padding(.top, 40)
                } else {
                    // Courses Grid
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 280), spacing: 20)],
                            spacing: 20
                        ) {
                            ForEach(COURSEARRAY.courses) { course in
                                CourseCard(
                                    title: course.title,
                                    drafts: course.drafts,
                                    quizzes: course.quizzes,
                                    attempted: course.attempted
                                ) {
                                    withAnimation {
                                        isTapped = true
                                        header = "Quizes"
                                        
                                        courseTitle = course.title
                                    }
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding()
                    }
                }
            } else {
                
                // Course Detail View
                CourseItemDetailView(
                    courseTitle: courseTitle,
                    selectedTab: $selectedTab,
                    _dismiss: {isTapped = false; header = "Courses"}
                )
                .transition(.move(edge: .trailing))
            }
            
            Spacer()
        }
        .background(AppColors.background(for: colorScheme))
        .navigationTitle("Courses")
    }
}



// MARK: - Stat Pill Component
struct StatPill: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(AppColors.textPrimary(for: colorScheme))
            
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary(for: colorScheme))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.1))
        .cornerRadius(20)
    }
}
