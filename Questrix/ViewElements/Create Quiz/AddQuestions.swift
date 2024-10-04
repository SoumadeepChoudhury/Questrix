//
//  AddQuestions.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 21/09/24.
//

import SwiftUI

struct AddQuestions: View {
    
    @Binding var course: String
    @Binding var title: String

    @State var question: String = ""
    @State var attachedFileURL: String = ""
    @State var isFileAttached: Bool = false
    @State var isMCQ: Bool = false
    @State var points: String = ""
//    @State var answerType: String = "Select..."
    @State var answerOptions: [String] = []
    @State var correctAnswer: String = ""
    @State var isTappedOnAdd: Bool = false
    @Binding var questionData: [[String:Any]]
    @State var isEmptyFieldPresnt: Bool = true
    
    @State var questionCounter: Int  = 1
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom){
                VStack(alignment: .leading){
                    Text("Questions").font(.title).fontWeight(.semibold)
                    Text("Add the questions & the correct answers here.").font(
                        .caption2)
                }.onAppear(perform: {
                    questionCounter = questionData.count + 1
                })
                Spacer()
                GroupBox {
                    Image(systemName: "plus").font(.title).help("Add this Question to the set.").onTapGesture {
                        
                        if(!question.isEmpty && !points.isEmpty && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: points)) && !correctAnswer.isEmpty){
                            isEmptyFieldPresnt = false
                            
                            if(isFileAttached && attachedFileURL.isEmpty){
                                isEmptyFieldPresnt = true
                            }
                            if(isMCQ && answerOptions.isEmpty){
                                isEmptyFieldPresnt = true
                            }
                        }
                        if(!attachedFileURL.isEmpty && !attachedFileURL.contains(".wav")){
                            var ext = ""
                            if(attachedFileURL.contains("png")){
                                ext = "png"
                            }else if(attachedFileURL.contains("jpeg")){
                                ext = "jpeg"
                            }else if(attachedFileURL.contains("jpg")){
                                ext = "jpg"
                            }
                            ContentView.fileManager.saveImage(filePath: attachedFileURL,course: course,title: title,number: questionCounter, ext: ext)
                            
                        }
                        self.isTappedOnAdd.toggle()
                    }.alert(isEmptyFieldPresnt ? "Empty Fields Present" : "Are you Sure, you wanna add this question to the Quiz? Cannot be edited later.", isPresented: $isTappedOnAdd) {
                        
                        if(!isEmptyFieldPresnt){
                            Button("Add") {
                                var ext = ""
                                if(attachedFileURL.contains("png")){
                                    ext = "png"
                                }else if(attachedFileURL.contains("jpeg")){
                                    ext = "jpeg"
                                }else if(attachedFileURL.contains("jpg")){
                                    ext = "jpg"
                                }
                                if(!ext.isEmpty){
                                    attachedFileURL = ContentView.fileManager.masterDirectory.path + "/\(course)/.\(title)_image_\(questionCounter).\(ext)"
                                }
                                questionData.append([
                                    "question" : question,
                                    "attached_file_url" : attachedFileURL,
                                    "points" : points,
                                    "answer_options" : answerOptions,
                                    "correct_answer" : correctAnswer
                                ])
                                question = ""
                                attachedFileURL = ""
                                points = ""
                                answerOptions = []
                                correctAnswer = ""
                                isFileAttached = false
                                isMCQ = false
                                questionCounter += 1
                            }
                        }
                        Button("Cancel"){
                            self.isTappedOnAdd.toggle()
                            isEmptyFieldPresnt = false
                        }
                    }
                }
            }
            Divider()
            QuestionBox(questionCounter: $questionCounter,course: $course,title: $title,question: $question,points: $points,correctAnswer: $correctAnswer,attachedFileURL: $attachedFileURL,isFileAttached: $isFileAttached,isMCQ: $isMCQ,options: $answerOptions)
        }
    }
}
