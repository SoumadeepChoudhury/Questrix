//
//  AddCourseView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 22/09/24.
//

import SwiftUI

struct AddCourseView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var courseName: String
    @State private var alertTitle: String = ""
    @State private var isAlertShown: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("New Course")
                    .font(AppFonts.largeTitle)
                
                Text("Create a new course to organize your quizzes")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Form
            VStack(spacing: 16) {
                TextField("Course Name", text: $courseName)
                    .textFieldStyle(PremiumTextFieldStyle())
                    .submitLabel(.done)
                    .focusable(false)
                
                HStack(spacing: 16) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .focusable(false)
                    Button("Create Course") {
                        createCourse()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(courseName.isEmpty)
                    .focusable(false)
                }
                .padding(.top, 8)
            }
        }
        .padding(24)
        .frame(minWidth: 400, minHeight: 200)
        .alert(alertTitle, isPresented: $isAlertShown) {
            Button("OK", role: .cancel) {
                if alertTitle == "Course created successfully!" {
                    dismiss()
                }
            }
        }
    }
    
    private func createCourse() {
        guard !courseName.isEmpty else {
            alertTitle = "Course name cannot be empty"
            isAlertShown = true
            return
        }
        
        let returnVal = ContentView.fileManager.createCourses(courseName: courseName)
        
        switch returnVal {
        case "Exist":
            alertTitle = "Course already exists"
        case "Error":
            alertTitle = "An error occurred. Please try again."
        case "Created":
            alertTitle = "Course created successfully!"
        default:
            alertTitle = "Unknown response"
        }
        
        isAlertShown = true
    }
}
