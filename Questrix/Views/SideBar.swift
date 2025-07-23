//
//  SideBar.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 18/09/24.
//
import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var user: User
    @Binding var selectedTab: String
    @Environment(\.colorScheme) var colorScheme
    
    
    @State private var isEditingUsername = false
    @State private var tempUsername = ""
    
    let tabs = [
        ("Dashboard", "house"),
        ("Courses", "book"),
        ("Create a Quiz", "plus.circle"),
        ("Create Quiz with AI","sparkles"),
        ("Upcoming Quizzes", "calendar"),
        ("Bookmarks", "bookmark")
    ]
    
    private func saveUsername() {
        withAnimation(.spring()) {
            if !tempUsername.isEmpty {
                user.UserName = tempUsername
                ContentView.fileManager.setUser(userName: tempUsername)
            }
            isEditingUsername = false
        }
    }

    private func cancelEditing() {
        withAnimation(.spring()) {
            isEditingUsername = false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Image(.icon)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .cornerRadius(AppShapes.smallCornerRadius)
                
                Text("Questrix")
                    .font(AppFonts.largeTitle)
                    .foregroundColor(AppColors.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            
            // Navigation
            VStack(spacing: 8) {
                ForEach(tabs, id: \.0) { tab in
                    SidebarButton(
                        icon: tab.1,
                        title: tab.0,
                        isActive: selectedTab == tab.0
                    ) {
                        withAnimation(.spring()) {
                            selectedTab = tab.0
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            
            Spacer()
            
            // User Profile
            HStack(spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(AppColors.accent)
                
                VStack(alignment: .leading) {
                    if isEditingUsername {
                        HStack(spacing: 8) {
                            TextField("Username", text: $tempUsername)
//                                .textFieldStyle(PremiumTextFieldStyle())
//                                .frame(width: 80)
                                .submitLabel(.done)
                                .onSubmit {
                                    saveUsername()
                                }
                            
                            Button(action: saveUsername) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppColors.success)
                                    .font(.title2)
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: cancelEditing) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppColors.error)
                                    .font(.title2)
                            }
                            .buttonStyle(.plain)
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        HStack(spacing: 4) {
                            Text(user.UserName)
                                .font(AppFonts.headline)
                                .lineLimit(1)
                            Spacer()
                            Image(systemName: "pencil")
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary(for: colorScheme))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                tempUsername = user.UserName
                                isEditingUsername = true
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    Text("Free Member")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                }
                
                Spacer()
            }
            .padding(12)
            .background(AppColors.cardBackground(for: colorScheme))
            .cornerRadius(AppShapes.mediumCornerRadius)
            .padding(.horizontal, 8)
            .padding(.bottom, 16)
        }
        .frame(minWidth:150)
        .background(AppColors.background(for: colorScheme))
    }
}

struct SidebarButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 24)
                    .foregroundColor(isActive ? AppColors.primary : AppColors.textSecondary(for: colorScheme))
                
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(isActive ? AppColors.primary : AppColors.textPrimary(for: colorScheme))
                
                Spacer()
                
                if isActive {
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(12)
            .background(isActive ? AppColors.primary.opacity(0.1) : Color.clear)
            .cornerRadius(AppShapes.mediumCornerRadius)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .focusable(false)
    }
}
