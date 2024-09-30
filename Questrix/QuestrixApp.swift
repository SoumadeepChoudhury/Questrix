//
//  QuestrixApp.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 18/09/24.
//

import SwiftUI

@main
struct QuestrixApp: App {
    
    @StateObject var COURSEARRAY: CoursesArray = CoursesArray()
    @StateObject var USER: User = User()
    @StateObject var QUIZARRAY: QuizArray = QuizArray()
    @StateObject var STARTQUIZ: StartQuiz = StartQuiz()
    @StateObject var BOOKMARK: BookmarkData = BookmarkData()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(COURSEARRAY).environmentObject(USER).environmentObject(QUIZARRAY).environmentObject(STARTQUIZ).environmentObject(BOOKMARK)
        }.windowStyle(HiddenTitleBarWindowStyle())
        
        WindowGroup(id: "PractisePage"){
            PractisePage().environmentObject(STARTQUIZ).environmentObject(BOOKMARK)
        }.windowStyle(HiddenTitleBarWindowStyle())
        
        WindowGroup(id: "BookMarkPreview"){
            BookMarkPreview().environmentObject(STARTQUIZ)
        }.windowStyle(HiddenTitleBarWindowStyle())
    }
    
}
