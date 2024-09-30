//
//  UpcomingTitle.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 22/09/24.
//

import SwiftUI

struct UpcomingTitle: View {
    @EnvironmentObject var QUIZARRAY: QuizArray
    @Binding var quiz: [QuizData]
    @Binding var search: String
    
    var body: some View {
        HStack{
            Text("Upcoming Quizzes").font(.largeTitle).fontWeight(.bold)
            Spacer()
            GroupBox{
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Search",text: $search).textFieldStyle(PlainTextFieldStyle()).onChange(of: search, {
                        quiz = []
                        for item in QUIZARRAY.quizzes {
                            if(item.title.contains(search)){
                                quiz.append(item)
                            }
                        }
                        if(search.isEmpty){
                            quiz = QUIZARRAY.quizzes
                        }
                    })
                }.clipShape(RoundedRectangle(cornerRadius: 10))
            }.frame(width: 150)
        }.padding(.vertical)
    }
}

//#Preview {
//    UpcomingTitle()
//}
