//
//  BookMarkPreview.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 28/09/24.
//

import SwiftUI

struct BookMarkPreview: View {

    @EnvironmentObject var STARTQUIZ: StartQuiz
    @State var questionCounter: Int = 0
    
    var body: some View {
        HStack{
            LeftPane(questionCounter: $questionCounter)
            Divider()
            RightPane(questionCounter: $questionCounter)
        }.background(VisualEffectView()).ignoresSafeArea()
    }
}


struct LeftPane: View {
    @EnvironmentObject var STARTQUIZ: StartQuiz
    @Binding var questionCounter: Int
    
    var body: some View {
        VStack(alignment: .leading){
            GroupBox{
                VStack(alignment: .leading){
                    Text("Course: \(STARTQUIZ.course)").font(.title2).lineLimit(1).help(STARTQUIZ.course)
                    Divider()
                    Text("Title: \(STARTQUIZ.title)").font(.title2).lineLimit(1).help(STARTQUIZ.title)
                }
            }.padding(.bottom).frame(width: 180)
            
            Text("OVERVIEW").font(.callout).foregroundStyle(.gray)
            GroupBox{
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 25))]){
                        if(!STARTQUIZ.questionData.isEmpty){
                            ForEach(0..<STARTQUIZ.questionData.count, id: \.self){ index in
                                Image(systemName: "square.circle").resizable().scaledToFit().onTapGesture(perform: {
                                    questionCounter = index
                                }).help("\(index+1)")
                            }
                        }
                    }
                }
            }.frame(width: 180)
                
            Spacer()
        }.padding()
    }
}

struct RightPane: View {
    @Environment(\.dismissWindow) var dismissWindow
    @EnvironmentObject var STARTQUIZ: StartQuiz
    @Binding var questionCounter: Int
    
    @State var correctAnswer: String = ""
    @State var nextOrClose: String = "Next"
    @State var attachedFileURL: String = ""
    @State var additionalFileIconName: String = "play.circle"
    @State var AUDIOPLAYER: AudioPlayer = AudioPlayer()
    
    var body: some View {
        VStack(alignment: .leading) {
            GroupBox {
                Text("Question \(questionCounter + 1)").font(.largeTitle)
            }
            
            Divider().padding(.bottom)
            GroupBox {
                if(!STARTQUIZ.questionData.isEmpty){
                    
                    ScrollView {
                    VStack(alignment: .leading) {
                        HStack{
                            Text(!(STARTQUIZ.questionData[questionCounter]["answer_options"] as! [String]).isEmpty ? "MULTIPLE CHOICE QUESTION" : "TYPE ANSWER - QUESTION").font(.callout).opacity(
                                0.8
                            ).padding(.bottom, 5).onAppear(perform: {
                                correctAnswer = STARTQUIZ.questionData[questionCounter]["correct_answer"] as! String
                                attachedFileURL = STARTQUIZ.questionData[questionCounter]["attached_file_url"] as! String
                                if(attachedFileURL.contains(".wav")){
                                    AUDIOPLAYER = AudioPlayer(filePath: attachedFileURL)
                                }
                            }).onChange(of: questionCounter, {
//                                AUDIOPLAYER.stopEngine()
                                correctAnswer = STARTQUIZ.questionData[questionCounter]["correct_answer"] as! String
                                attachedFileURL = STARTQUIZ.questionData[questionCounter]["attached_file_url"] as! String
                                if(attachedFileURL.contains(".wav")){
                                    AUDIOPLAYER = AudioPlayer(filePath: attachedFileURL)
                                }
                            })
                            Spacer()
                        }
                        Text(STARTQUIZ.questionData[questionCounter]["question"] as! String).font(.title).padding(
                            .bottom)
                        if(attachedFileURL.contains(".jpeg") || attachedFileURL.contains(".jpg") || attachedFileURL.contains(".png")){
                            Image(nsImage: NSImage(contentsOfFile: attachedFileURL)!)
                                .resizable().frame(width: 200, height: 200).clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                        }else if(attachedFileURL.contains(".wav")){
                            //Show the player option -> Done
                            Image(systemName: additionalFileIconName).resizable().frame(width:50, height: 50).onTapGesture(perform: {
                                if(additionalFileIconName == "play.circle"){
                                    AUDIOPLAYER.play()
                                    additionalFileIconName = "pause.circle"
                                }else if additionalFileIconName == "pause.circle"{
                                    AUDIOPLAYER.pause()
                                    additionalFileIconName = "play.circle"
                                }
                            })
                        }
                        
                        
                        Divider().padding(.bottom)
                        if(!(STARTQUIZ.questionData[questionCounter]["answer_options"] as! [String]).isEmpty){
                            ForEach(0..<(STARTQUIZ.questionData[questionCounter]["answer_options"] as! [String]).count,id: \.self) { index in
                                Button(
                                    action: {
//                                        answer = questionData[questionCounter].options[index]
                                    },
                                    label: {
                                        HStack{
                                            Image(systemName: correctAnswer == (STARTQUIZ.questionData[questionCounter]["answer_options"] as! [String])[index] ? "inset.filled.circle" : "circle").foregroundStyle(correctAnswer == (STARTQUIZ.questionData[questionCounter]["answer_options"] as! [String])[index] ? .blue : .gray)
                                            Text((STARTQUIZ.questionData[questionCounter]["answer_options"] as! [String])[index])
                                        }.font(.title2)
                                    }
                                ).padding(.bottom).buttonStyle(.plain).disabled(true)
                            }
                        }else{
                            Text("Correct Answer: ").font(.title3)
                            TextEditor(text: $correctAnswer).font(.title3).frame(
                                height: 150
                            ).scrollContentBackground(.hidden).overlay(content: {
                                RoundedRectangle(
                                    cornerRadius: 8, style: .continuous
                                ).stroke(.gray.opacity(0.3), lineWidth: 1)
                            }).disabled(true)
                        }
                        
                        HStack{
                            
                            if(questionCounter != 0){
                                Button("Previous"){
                                    questionCounter -= 1
                                }.buttonStyle(.plain).padding()
                                    .overlay(content: {
                                        Capsule().stroke(lineWidth: 1)
                                            .foregroundStyle(.blue)
                                            .frame(height: 30)
                                    })
                            }
                            Spacer()
                            Button(nextOrClose){
                                if(nextOrClose == "Close"){
                                    dismissWindow(id: "BookMarkPreview")
                                }
                                if(questionCounter < STARTQUIZ.questionData.count - 1 ){
                                    questionCounter += 1
                                }
                                if(questionCounter == STARTQUIZ.questionData.count - 1){
                                    nextOrClose = "Close"
                                }
                            }.buttonStyle(.plain).padding()
                                .overlay(content: {
                                    Capsule().stroke(lineWidth: 1)
                                        .foregroundStyle(.blue)
                                        .frame(height: 30)
                            })
                        }
                        
                    }
                }
                    
                }
            }
            Spacer()
        }.padding()
    }
}
