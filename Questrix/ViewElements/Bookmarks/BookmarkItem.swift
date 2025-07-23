//
//  BookmarkItem.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 22/09/24.
//
import SwiftUI

struct BookmarkCard: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var startQuiz: StartQuiz
    
    let bookmark: Bookmark
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .top) {
                Image(systemName: "bookmark.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.accent)
                    .frame(width: 44, height: 44)
                    .background(AppColors.accent.opacity(0.1))
                    .cornerRadius(AppShapes.smallCornerRadius)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(bookmark.title)
                        .font(AppFonts.headline)
                        .lineLimit(2)
                    
                    Text(bookmark.course)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                }
                
                Spacer()
            }
            
            // Stats
            HStack(spacing: 16) {
                StatPill(
                    icon: "questionmark.circle",
                    value: "\(bookmark.questionData.count)",
                    label: "Questions",
                    color: AppColors.primary
                )
            }
            
            // Action Button
            Button(action: openBookmarkPreview) {
                HStack {
                    Text("View Questions")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .font(AppFonts.headline)
                .padding(.vertical, 12)
                .padding(.horizontal,12)
                .frame(maxWidth: .infinity)
                .background(AppColors.primary.opacity(0.1))
                .foregroundColor(AppColors.primary)
                .cornerRadius(AppShapes.smallCornerRadius)
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(AppShapes.mediumCornerRadius)
        .shadow(color: AppColors.primary.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func openBookmarkPreview() {
        startQuiz.course = bookmark.course
        startQuiz.title = bookmark.title
        startQuiz.questionData = bookmark.questionData
        openWindow(id: "BookMarkPreview")
    }
}

// MARK: - Preview Extension
extension BookmarkData {
    static var sampleData: BookmarkData {
        let data = BookmarkData()
        data.bookmarks = [
            Bookmark(
                course: "Mathematics",
                title: "Algebra Fundamentals",
                questionData: [[:]]
            ),
            Bookmark(
                course: "Science",
                title: "Physics Basics",
                questionData: [[:]]
            )
        ]
        return data
    }
}
