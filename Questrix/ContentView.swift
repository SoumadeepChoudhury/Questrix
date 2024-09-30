//
//  ContentView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 18/09/24.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var COURSESARRAY: CoursesArray
    @EnvironmentObject var USER: User
    @EnvironmentObject var QUIZARRAY: QuizArray
    @EnvironmentObject var BOOKMARK: BookmarkData
    
    static var fileManager: FileManagement = FileManagement()
    
    
    var colorScheme=ColorScheme.dark
    @State var sideBarVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedTab:String = "Dashboard"
    
    var body: some View {
        NavigationSplitView(columnVisibility: $sideBarVisibility) {
            let SideBar:SideBar=SideBar(selectedTab: self.$selectedTab)
            SideBar.onAppear(perform: {
                ContentView.fileManager = FileManagement(coursesArray: COURSESARRAY,quizArray: QUIZARRAY,user: USER,bookmark: BOOKMARK)
                ContentView.fileManager.getCourses()
                ContentView.fileManager.getAllQuizzes()
            })
        }
        detail: {
            switch selectedTab {
            case "Dashboard":Dashboard()
            case "Courses":Courses(selectedTab: $selectedTab)
            case "Create a Quiz":CreateQuiz()
            case "Upcoming Quizzes":UpcomingQuizzes()
            case "Bookmarks":Bookmarks()
            default:Dashboard()
            }
        }
        
        .frame(minWidth: 800,minHeight: 600)
        .background(VisualEffectView().ignoresSafeArea())
    }
}


struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.state = .active
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}



#Preview {
    ContentView().environmentObject(CoursesArray())
}

#Preview {
    ContentView().preferredColorScheme(.light).environmentObject(CoursesArray())
}
