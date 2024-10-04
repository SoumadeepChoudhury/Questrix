//
//  CreateQuiz.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 19/09/24.
//

import SwiftUI

struct CreateQuiz: View {
    
    @EnvironmentObject var QUIZARRAY: QuizArray
    
    @State var step: Int = 1
    
    //Step 1
    @State var selectedCourse: String = "Select Course..."
    //Step 2
    @State var title: String = ""
    @State var description: String = ""
    //Step 3
    @State var questionData: [[String : Any]] = []
    //Step 4
//    @State var isRandomAllowed: Bool = true
    @State var duration: String = ""
//    @State var isUnlimitedRep: Bool = false
//    @State var isLimitedRep: Bool = false
//    @State var isNoRep: Bool = false
//    @State var limit: String = "0"
    @State var publishStatus: String = "Select..."
    @State var publishDate: Date = Date()
    
    
    @State var isConfirmQuestionAddedAlertDisplayed: Bool = false
    @State var enterCourseToSaveAsDraft: Bool = false
    @State var confirmSaveAsDraft: Bool = false
//    @State var isRefferedFromEdit: Bool = ContentView.fileManager.isRefferedFromEdit
    @State var isPresent: Bool = false
    
    var body: some View {
        
        VStack{
            
            //DateTime
            DateTime().onAppear(perform: {
                if(ContentView.fileManager.isRefferedFromEdit){
                    selectedCourse = ContentView.fileManager.getDataFromDraft(item: "Course") as! String
                    title = ContentView.fileManager.getDataFromDraft(item: "Title") as! String
                    description = ContentView.fileManager.getDataFromDraft(item: "Description") as! String
                    duration = ContentView.fileManager.getDataFromDraft(item: "Duration") as! String
                    publishDate = ContentView.fileManager.getDataFromDraft(item: "Release Date") as! Date
                    questionData = ContentView.fileManager.getDataFromDraft(item: "Question Data") as! [[String:Any]]
                }
            })
            
            //Title
            Heading(enterCourseToSaveAsDraft: $enterCourseToSaveAsDraft,step: $step,confirmSaveAsDraft: $confirmSaveAsDraft).alert("Cannot save as draft in step \(step). Click 'Next'", isPresented: $enterCourseToSaveAsDraft, actions: {
                Button("Ok"){
                    enterCourseToSaveAsDraft.toggle()
                }
            }).alert("Confirm Save as Draft", isPresented: $confirmSaveAsDraft, actions: {
                Button("Ok"){
                    ContentView.fileManager.createQuiz(course: selectedCourse,title: title,description: description,questionData: questionData,duration: duration != "" ? Int(duration)! : 0,publishDate: publishDate,isDrafted: true)
                    confirmSaveAsDraft.toggle()
                }
                Button("Cancel"){
                    confirmSaveAsDraft.toggle()
                }
            })
            
            
            
            
            
            //Step Info Animation
            StepCompletionInfo(step: $step)
            
            //Main View
            switch step{
            case 1:
                Section{
                    SelectCourse(selectedCourse: $selectedCourse)
                }.padding(.vertical)
            
            case 2:
                Section{
                    BasicInfo(title: $title, description: $description).alert("Quiz with same title already present.", isPresented: $isPresent, actions: {
                        Button("Ok"){
                            isPresent = false
                        }
                    })
                }
            case 3:
                Section{
                    AddQuestions(course: $selectedCourse,title: $title,questionData: $questionData)
                }
            case 4:
                Section{
//                    Settings(isRandomAllowed: $isRandomAllowed, duration: $duration,isUnlimitedRep: $isUnlimitedRep, isLimitedRep: $isLimitedRep, isNoRep: $isNoRep, limit: $limit, publishStatus: $publishStatus, publishDate: $publishDate)
                    Settings(duration: $duration,publishStatus: $publishStatus, publishDate: $publishDate)
                }
            default:
                Section{
                    SelectCourse(selectedCourse: $selectedCourse)
                }.padding(.vertical)
            }
            
            
            
            //Button for Next
            HStack{
                
                if(step > 1){
                    Text("Previous").font(.title2).fontWeight(.semibold).padding().overlay(content: {
                        Capsule().stroke(lineWidth: 2).foregroundStyle(.blue)
                    }).onTapGesture {
                        step -= 1
                    }
                }
                Spacer()
                Text(step == 4 ? "Finish" : "Next").font(.title2).fontWeight(.semibold).padding().overlay(content: {
                    Capsule().stroke(lineWidth: 2).foregroundStyle(.blue)
                }).onTapGesture {
                    if(step == 4) {
                        
                        if(!title.isEmpty && !selectedCourse.isEmpty && selectedCourse != "Select Course..." && !questionData.isEmpty && publishStatus != "Select..." && !duration.isEmpty && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: duration))){
                            ContentView.fileManager.createQuiz(course: selectedCourse,title: title,description: description,questionData: questionData,duration: Int(duration)!,publishDate: publishDate);
                            ContentView.fileManager.isRefferedFromEdit = false
                            
                            title = "";
                            description = "";
                            questionData = [];
                            duration = "";
                            publishStatus = "Select...";
                            publishDate = Date();
                            
                            step = 2;
                        }
                    }
                    else if(step == 3){
                        isConfirmQuestionAddedAlertDisplayed = true
                    }
                    else if(step == 2){
                        if(!title.isEmpty){
                            for quiz in QUIZARRAY.quizzes{
                                if(quiz.title == title && !ContentView.fileManager.isRefferedFromEdit){
                                    isPresent = true
                                    break
                                }
                            }
                            if(!isPresent){
                                step += 1
                            }
                        }
                    }
                    else if(step == 1){
                        if(!selectedCourse.isEmpty && selectedCourse != "Select Course..." ){
                            step += 1
                        }
                    }
                    
                    
                    
                }.alert("Confirm if you have tapped in 'Add this Question' button ", isPresented: $isConfirmQuestionAddedAlertDisplayed, actions: {
                    Button("Yes"){
                        isConfirmQuestionAddedAlertDisplayed = false
                        if(!questionData.isEmpty){
                            step += 1
                        }
                    }
                    Button("Cancel"){
                        isConfirmQuestionAddedAlertDisplayed = false
                    }
                })
            }
            
            Spacer()
        }.padding()
    }
}

#Preview {
    CreateQuiz().frame(height: 720)
}
