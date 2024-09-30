//
//  UpcomingQuizzes.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 19/09/24.
//

import SwiftUI

struct UpcomingQuizzes: View {
    
    @EnvironmentObject var QUIZARRAY: QuizArray
    @State var useLess: String = ""
    @State var search: String = ""
    @State var quizzesToDisplay: [QuizData] = []
    
    var body: some View {
        VStack{
            //DateTime
            DateTime()
            
            //Title
            UpcomingTitle(quiz: $quizzesToDisplay,search: $search).onAppear(perform: {
                quizzesToDisplay = QUIZARRAY.quizzes
            }).onChange(of: QUIZARRAY.quizzes.count, {
                quizzesToDisplay = QUIZARRAY.quizzes
            })
            
            //Quiz List
            if(!QUIZARRAY.quizzes.isEmpty){
                
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 180))]){
                        ForEach(search.isEmpty ? QUIZARRAY.quizzes : quizzesToDisplay){ quiz in
                            if(quiz.releaseDate<=Date() && !quiz.isDrafted){
                                QuizItemView(title: quiz.title, releaseDate: quiz.releaseDate, duration: "\(quiz.duration)", totalQuestions: quiz.questionsData.count, isAttempted: quiz.isAttempted,course: quiz.course,selectedTab: $useLess,newORstartButtonText: quiz.isAttempted ? "Re-Attempt" : "Start")
                            }
                        }
                    }
                }
            }else{
                Spacer()
                Image(systemName: "hockey.puck").resizable().frame(width: 300,height: 300).opacity(0.2)
            }
            Spacer()
        }.padding()
    }
}

#Preview {
    UpcomingQuizzes()
}
