//
//  ContentOverview.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct ContentOverview: View {
    @EnvironmentObject var COURSEARRAY: CoursesArray
    @EnvironmentObject var QUIZARRAY: QuizArray
    
    var body: some View {
        HStack {
//            Spacer()
            CardView(icon: "book", title: "Total Courses", numberOfItems: COURSEARRAY.courses.count)
            Spacer()
            CardView(icon: "questionmark.text.page", title: "Total Quizzes Created", numberOfItems: QUIZARRAY.quizzes.count)
            Spacer()
            CardView(icon: "square.and.pencil.circle", title: "Total Quizzes Attempted", numberOfItems: ContentView.fileManager.getAttemptedQuizCount())
//            Spacer()
        }
    }
}


struct CardView: View {
    var icon: String
    var title: String
    var numberOfItems: Int
    var body: some View {
        GroupBox{
            VStack(){
                Image(systemName: icon).font(.title)
                Text(title).font(.title).fontWeight(.semibold)
                Text("\(numberOfItems)").font(.title)
            }
        }
    }
    
}
