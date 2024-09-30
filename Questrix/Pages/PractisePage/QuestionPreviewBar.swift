//
//  QuestionPreviewBar.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 26/09/24.
//

import SwiftUI

struct QuestionPreviewBar: View {
    @EnvironmentObject var STARTQUIZ: StartQuiz
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var desc: String
    @Binding var questionData: [QuestionData]
    @Binding var questionCounter: Int
    @Binding var givenAnswers: [String]
    
    var body: some View {
        let multiplierVal = !questionData.isEmpty ? 100*(questionCounter+1)/questionData.count : 0
        VStack(alignment: .leading){
            GroupBox{
                VStack(alignment: .leading){
                    Text("Course: \(STARTQUIZ.course)").font(.title2).lineLimit(1).help(STARTQUIZ.course)
                    Divider()
                    Text("Title: \(STARTQUIZ.title)").font(.title2).lineLimit(1).help(STARTQUIZ.title)
                    Text("Description: \(desc)").font(.title2).lineLimit(1).help(desc)
                }.onAppear(perform: {
                    givenAnswers = Array(repeating: "", count: questionData.count)
                })
            }.padding(.bottom).frame(width: 180)
            //ProgressBar
            VStack(alignment: .leading){
                if !STARTQUIZ.isReview {
                    HStack{
                        //headers
                        Text("\(multiplierVal)% complete")
                        Spacer()
                        Text("\(givenAnswers.count - (questionCounter + 1)) left")
                    }
                    //bar
                    ZStack(alignment: .leading){
                        Capsule().frame(width: 180, height: 10).foregroundStyle(colorScheme == .light ? .gray : .white.opacity(0.6))
                        
                        Capsule().frame(width: 180 * CGFloat(multiplierVal) / 100, height: 10)
                            .foregroundStyle(.blue.gradient).animation(.spring(), value: multiplierVal)
                    }.padding(.bottom)
                }
                Text("OVERVIEW").font(.callout).foregroundStyle(.gray)
                GroupBox{
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 25))]){
                            if(!questionData.isEmpty){
                                ForEach(0..<questionData.count,id: \.self){ index in
                                    Image(systemName: "square.circle\(!givenAnswers[index].isEmpty ? ".fill" : "")").resizable().scaledToFit().onTapGesture(perform: {
                                        questionCounter = index
                                    }).help("\(index+1)")
                                }
                            }
                        }
                    }
                }.frame(width: 180)
                
            }
            Spacer()
        }.padding()
    }
}
