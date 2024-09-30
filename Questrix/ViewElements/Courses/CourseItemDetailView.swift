//
//  CourseItemDetailView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct CourseItemDetailView: View {
    
    @EnvironmentObject var QUIZARRAY: QuizArray
    

    var courseTitle: String
    @Binding var isTapped: Bool
    @Binding var selectedTab: String
    

    var body: some View {
//        let QUIZZES: [QuizData] = ContentView.fileManager.getQuizzes(selectedCourse: courseTitle)

        if !QUIZARRAY.quizzes.isEmpty {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 180))]) {
                    ForEach(QUIZARRAY.quizzes) { quiz in
                        if(courseTitle == quiz.course){
                            QuizItemView(
                                title: quiz.title, releaseDate: quiz.releaseDate,
                                duration: "\(quiz.duration)",
                                totalQuestions: quiz.questionsData.count,
                                isAttempted: quiz.isAttempted,
                                isDrafted: quiz.isDrafted,
                                courseName: quiz.course,
                                selectedTab: $selectedTab)
                        }
                    }
                }
            }.toolbar(content: {
                Image(systemName: "arrowshape.turn.up.backward").font(.title)
                    .onTapGesture {
                        self.isTapped = false
                    }
            })
        }
        else{
            Spacer()
            Image(systemName: "hockey.puck").resizable().frame(width: 300,height: 300).opacity(0.2).toolbar(content: {
                Image(systemName: "arrowshape.turn.up.backward").font(.title)
                    .onTapGesture {
                        self.isTapped = false
                    }
            })
        }
        Spacer()
    }
}

struct QuizItemView: View {
    
    @Environment(\.openWindow) var openWindow
    @EnvironmentObject var STARTQUIZ: StartQuiz
    
    var title: String
    var releaseDate: Date
    var duration: String
    var totalQuestions: Int
    var isAttempted: Bool
    var isDrafted: Bool = false
    var course: String = ""
    var courseName: String = ""
    @State var isDeleteTapped:Bool = false
    @Binding var selectedTab: String
    var newORstartButtonText: String = "New"

    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "document.on.document").font(.title)
                    Text(title).font(.title).fontWeight(.semibold).lineLimit(1)
                        .help(title)
                    Spacer()
                    if(course.isEmpty){
                        Image(systemName: "trash").onTapGesture {
                            //code : delete quiz
                            isDeleteTapped = true
                        }.alert("Are you sure to delete \(title).", isPresented: $isDeleteTapped, actions: {
                            Button("Yes"){
                                isDeleteTapped = false
                                ContentView.fileManager.deleteQuiz(course: courseName,title: title,isSubmitted: false)
                            }
                        })
                    }
                }.padding(.bottom)
                if(!course.isEmpty){
                    Text("Course: \(course)")
                }
                Text("Total Questions: \(totalQuestions)")
                HStack {
                    Text("Duration: ")
                    Text("\(duration) min").lineLimit(1).help(
                        duration)
                }
                HStack {
                    Text("Release Date: ").lineLimit(1)
                    Text(releaseDate, style: .date).lineLimit(1).help(
                        releaseDate.formatted())
                }
            }.padding()
            Button(
                action: {
                    if(isDrafted){
                        ContentView.fileManager.setDraftDataSet(course: courseName, title: title)
                        ContentView.fileManager.isRefferedFromEdit = true
                        selectedTab = "Create a Quiz"
                    }else if(!isDrafted && (newORstartButtonText == "Start" || newORstartButtonText == "Re-Attempt")){
                        STARTQUIZ.course = course
                        STARTQUIZ.title = title
                        if(newORstartButtonText == "Re-Attempt"){
                            STARTQUIZ.isReAttempt = true
                            STARTQUIZ.isReview = false
                        }
                        openWindow(id: "PractisePage")
                    } else if(isAttempted){
                        STARTQUIZ.course = courseName
                        STARTQUIZ.title = title
                        STARTQUIZ.isReview = true
                        STARTQUIZ.isReAttempt = false
                        openWindow(id: "PractisePage")
                    }
                },
                label: {
                    if(isAttempted && newORstartButtonText != "Re-Attempt"){
                        Text("Review")
                    }else if(isDrafted){
                        Text("Edit")
                    }else{
                        Text(newORstartButtonText)
                    }
                }
            )
            .foregroundStyle(isAttempted ? .blue : (isDrafted ? .red : .green))
            .buttonStyle(.borderless)
            .overlay(content: {
                Capsule().stroke(lineWidth: 1)
                    .foregroundStyle(isAttempted ? .blue : (isDrafted ? .red : .green))
                    .frame(width: 100, height: 20)
            })
        }
    }
}
