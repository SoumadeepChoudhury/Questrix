import SwiftUI

struct Bookmarks: View {
    @EnvironmentObject var bookmarkData: BookmarkData
    @EnvironmentObject var COURSEARRAY: CoursesArray
    @State private var selectedCourse: String = "All Courses"
    @State private var searchText: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    var filteredBookmarks: [Bookmark] {
        var filtered = bookmarkData.bookmarks
        
        // Filter by selected course
        if selectedCourse != "All Courses" {
            filtered = filtered.filter { $0.course == selectedCourse }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.course.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var availableCourses: [String] {
        var courses = Set<String>()
        COURSEARRAY.courses.forEach { courses.insert($0.title) }
        return ["All Courses"] + courses.sorted()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            BookmarkHeader(
                selectedCourse: $selectedCourse,
                searchText: $searchText,
                courses: availableCourses
            )
            .padding(.horizontal)
            .padding(.top, 12)
            .background(AppColors.cardBackground(for: colorScheme))
            .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
            
            // Content
            if bookmarkData.bookmarks.isEmpty {
                EmptyStateView(
                    icon: "bookmark",
                    title: "No Bookmarks Yet",
                    message: "Save important questions by bookmarking them during quizzes."
                )
                .padding(.top, 40)
            } else if filteredBookmarks.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "No Matching Bookmarks",
                    message: "Try adjusting your filters to find what you're looking for."
                )
                .padding(.top, 40)
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 300), spacing: 20)],
                        spacing: 20
                    ) {
                        ForEach(filteredBookmarks) { bookmark in
                            BookmarkCard(bookmark: bookmark)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .background(AppColors.background(for: colorScheme))
        .navigationTitle("Bookmarks")
        .onAppear {
            ContentView.fileManager.getBookmarks()
        }
    }
}

#Preview {
    Bookmarks()
        .environmentObject(BookmarkData.sampleData)
        .frame(width: 800, height: 600)
}
