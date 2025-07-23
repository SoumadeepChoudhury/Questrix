//
//  CourseViewItem.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI
// MARK: - Course Card Component
struct CourseCard: View {
    let title: String
    let drafts: Int
    let quizzes: Int
    let attempted: Int
    let action: () -> Void
    
    @State private var showAlertDialog: Bool = false
    @State private var alertMsg: String = ""
    
    @State private var isActionSucessful: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack(spacing: 12) {
                    Image(systemName: "book.closed.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.primary)
                        .frame(width: 44, height: 44)
                        .background(AppColors.primary.opacity(0.1))
                        .cornerRadius(AppShapes.smallCornerRadius)
                    
                    Text(title)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary(for: colorScheme))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "xmark")
                        .onTapGesture {
                            //Ask to Delete the course
                            showAlertDialog = true
                            
                        }
                        .alert("Are You Sure? Delete: \(title)", isPresented: $showAlertDialog){
                            Button("Yes"){
                                //Delete the course
                                isActionSucessful = ContentView.fileManager.deleteCourse(courseName: title)
                            }
                            Button("No"){
                                showAlertDialog.toggle()
                            }
                        }
                        .alert("\(title) deleted sucessfully", isPresented: $isActionSucessful){ Button("Ok"){
                                isActionSucessful = false
                            }
                        }
                }
                
                // Stats
                HStack(spacing: 16) {
                    StatPill(
                        icon: "doc.text",
                        value: "\(drafts)",
                        label: "Drafts",
                        color: AppColors.secondary
                    )
                    
                    StatPill(
                        icon: "questionmark.square",
                        value: "\(quizzes)",
                        label: "Quizzes",
                        color: AppColors.accent
                    )
                    
                    StatPill(
                        icon: "checkmark.square",
                        value: "\(attempted)",
                        label: "Attempted",
                        color: AppColors.primary
                    )
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground(for: colorScheme))
            .cornerRadius(AppShapes.mediumCornerRadius)
            .shadow(color: AppColors.primary.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
