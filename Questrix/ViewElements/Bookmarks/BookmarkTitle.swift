//
//  BookmarkTitle.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 22/09/24.
//
import SwiftUI

struct BookmarkHeader: View {
    @Binding var selectedCourse: String
    @Binding var searchText: String
    let courses: [String]
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bookmarks")
                        .font(AppFonts.largeTitle)
                    
                    Text("Your bookmarked questions")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                }
                
                Spacer()
                
                // Course Filter
                Menu(selectedCourse) {
                    ForEach(courses, id: \.self) { course in
                        Button(action: { selectedCourse = course }) {
                            HStack {
                                Text(course)
                                if selectedCourse == course {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
                    .font(AppFonts.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(width: 200,alignment: .leading)
                    .background(AppColors.cardBackground(for: colorScheme))
                    .cornerRadius(AppShapes.mediumCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppShapes.mediumCornerRadius)
                            .stroke(AppColors.textSecondary(for: colorScheme).opacity(0.2), lineWidth: 1)
                    )
                }
                
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
                
                TextField("Search bookmarks...", text: $searchText)
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
        }
        .padding(.vertical, 12)
    }
}
