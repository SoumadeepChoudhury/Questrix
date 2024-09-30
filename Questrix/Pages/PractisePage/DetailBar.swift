//
//  DetailBar.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 26/09/24.
//

/*
 [["answer_options": <__NSArray0 0x1f848e1a0>(

 )
 , "correct_answer": Nothing, "attached_file_url": , "points": 10, "question": What is your name?], ["attached_file_url": , "answer_options": <__NSArrayI 0x6000009bd3e0>(
 Hello World!,
 Gello World!
 )
 , "correct_answer": Gello World!, "question": Select option!, "points": 10]]
 
 */

import SwiftUI

struct DetailBar: View {
    
    @EnvironmentObject var STARTQUIZ: StartQuiz
    @EnvironmentObject var BOOKMARK: BookmarkData
    @Environment(\.dismissWindow) var dismissWindow

    
    @State var answer: String = ""
    @State var duration: String = ""
    @State var minute: Int = 0
    @State var seconds: Int = 0
    @State var isQuizJustStarted: Bool = true
    @State var options: [String] = []
    @State var isReadyToSubmit: Bool = false
    @State var isAllQuestionCompleted: Bool = false
    @State var questionDataSet: [[String:Any]] = []
    @State var publishDate: Date = Date()
    @State var latestAnswersIfReviewed: [String] = []
    @State var correctAnswerIfReviewed: String = ""
    @State var bookmarkedQuestionsSet: [[String:Any]] = []
    @State var isBookmarked: [Bool] = []
    @State var additionalFileIconName: String = "play.circle"
    @State var AUDIOPLAYER: AudioPlayer = AudioPlayer()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    @Binding var desc: String
    @Binding var questionData: [QuestionData]
    @Binding var questionCounter: Int
    @Binding var givenAnswers: [String]
    @Binding var isSubmitted: Bool
    

    func checkAnswers(){
        var pointsScored: Int = 0
        var totalPoints: Int = 0
        var counter: Int = 0
        for ans in givenAnswers{
            if(ans == questionData[counter].correctAnswer){
                pointsScored += questionData[counter].points
                totalPoints += questionData[counter].points
            }else{
                totalPoints += questionData[counter].points
            }
            counter += 1
        }
        
        ContentView.fileManager.updateExistingQuizToAttempted(course: STARTQUIZ.course, title: STARTQUIZ.title, description: desc, questionData: questionDataSet,latestGivenAnswers: givenAnswers, duration: Int(duration) ?? 0, publishDate: publishDate)
        let resultData: [String:Any] = ["Course":STARTQUIZ.course,"Title":STARTQUIZ.title,"Date Attempted": Date(),"Points Scored":pointsScored,"Total Points": totalPoints]
        ContentView.fileManager.updateQuizResultData(resultData: resultData)
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            GroupBox {
                HStack {
                    Spacer()
                    Text("Question \(questionCounter+1)").font(.largeTitle).onAppear(perform: {
                        let quizData: [String:Any] = FileManagement().getQuizData(courseName: STARTQUIZ.course, title: STARTQUIZ.title, ext: (STARTQUIZ.isReAttempt || STARTQUIZ.isReview) ? "attempted" : "quiz")
                        
                        if(!quizData.isEmpty){
                            duration = "\(quizData["Duration"] as! Int)"
                            desc = quizData["Description"] as! String
                            questionDataSet = quizData["QuestionData"] as! [[String:Any]]
                            ContentView.fileManager.getBookmarks()
                            isBookmarked = Array(repeating: false, count: questionDataSet.count)
                            for item in questionDataSet{
                                for item1 in BOOKMARK.bookmarks{
                                    if(item1.course == STARTQUIZ.course && item1.title == STARTQUIZ.title){
                                        for item2 in item1.questionData{
                                            if(NSDictionary(dictionary: item).isEqual(to: item2)){
                                                let index = questionDataSet.firstIndex(where: { NSDictionary(dictionary: $0).isEqual(to: item) })
                                                isBookmarked[index!].toggle()
                                                bookmarkedQuestionsSet.append(item)
                                            }
                                        }
                                    }
                                }
                            }
                            publishDate = quizData["PublishDate"] as! Date
                            latestAnswersIfReviewed = STARTQUIZ.isReview ? quizData["LatestAnswers"] as! [String] : []
                            questionDataSet.forEach({ question in
                                var questionType: String
                                if((question["attached_file_url"] as! String).isEmpty){
                                    questionType = "TBQ"
                                }else{
                                    questionType = "FAQ"
                                }
                                questionData.append(QuestionData(question: question["question"] as! String, questionType: questionType, attachedFileURL: question["attached_file_url"] as! String, options: question["answer_options"] as! [String], correctAnswer: question["correct_answer"] as! String, points: Int(question["points"] as! String) ?? 0))
                                
                            })
                        }
                    })
                    Spacer()
                    if !STARTQUIZ.isReview {
                        Text("\(String(format: "%02d:%02d",minute,seconds))").font(.largeTitle).onReceive(timer, perform: { _ in
                            if(isQuizJustStarted){
                                if( duration != "" ){
                                    minute = Int(duration)!
                                }
                            }
                            if minute == 0 && seconds == 0 && !STARTQUIZ.isReview && !isQuizJustStarted{
                                timer.upstream.connect().cancel()
                                isSubmitted = true
                                checkAnswers()
                            }
                            if seconds == 0 {
                                isQuizJustStarted = false
                                seconds = 60
                                minute -= 1
                            }
                            seconds -= 1
                        })
                    }else {
//                        let _ = isBookmarked = Array(repeating: false, count: questionData.count)
                        let _ = timer.upstream.connect().cancel()
                        var scoredPoints: Int = 0
                        var totalPoints: Int = 0
                        if(!questionData.isEmpty){
                            let _ = totalPoints = questionData[questionCounter].points
                            if(questionData[questionCounter].correctAnswer == latestAnswersIfReviewed[questionCounter]){
                                let _ = scoredPoints = questionData[questionCounter].points
                            }
                        }
                        Text("PS: \(scoredPoints) / \(totalPoints)").font(.largeTitle).onChange(of: questionCounter, {
                            answer = latestAnswersIfReviewed[questionCounter]
                            correctAnswerIfReviewed = questionData[questionCounter].correctAnswer
                        })
                    }
                }
            }
            
            Divider().padding(.bottom)
            GroupBox {
                if(!questionData.isEmpty){
                    
                    ScrollView {
                    VStack(alignment: .leading) {
                        HStack{
                            Text(!questionData[questionCounter].options.isEmpty ? "MULTIPLE CHOICE QUESTION" : "TYPE ANSWER - QUESTION").font(.callout).opacity(
                                0.8
                            ).padding(.bottom, 5).onAppear(perform: {
                                answer = STARTQUIZ.isReview ? latestAnswersIfReviewed[questionCounter] : ""
                                correctAnswerIfReviewed = STARTQUIZ.isReview ? questionData[questionCounter].correctAnswer : ""
                            }).onChange(of: questionCounter, {
                                answer = givenAnswers[questionCounter]
                                isAllQuestionCompleted = false
                            })
                            Spacer()
                            if STARTQUIZ.isReview{
                                Image(systemName: isBookmarked[questionCounter] ? "bookmark.fill" : "bookmark").resizable().frame(width: 15,height: 20).onTapGesture {
                                    //Bookmark the question
                                    if(isBookmarked[questionCounter]){
                                        bookmarkedQuestionsSet.removeAll(where: {NSDictionary(dictionary: $0).isEqual(to: questionDataSet[questionCounter])})
                                    }else{
                                        bookmarkedQuestionsSet.append(questionDataSet[questionCounter])
                                    }
                                    isBookmarked[questionCounter].toggle()
                                }.foregroundStyle(isBookmarked[questionCounter] ? .blue : .gray)
                            }
                        }
                        Text(questionData[questionCounter].question).font(.title).onAppear(perform: {
                            if(questionData[questionCounter].attachedFileURL.contains(".wav")){
                                AUDIOPLAYER = AudioPlayer(filePath: questionData[questionCounter].attachedFileURL)
                            }
                        }).onChange(of: questionCounter, {
//                            AUDIOPLAYER.stopEngine()
                            print(questionData[questionCounter].attachedFileURL)
                            if(questionData[questionCounter].attachedFileURL.contains(".wav")){
                                AUDIOPLAYER = AudioPlayer(filePath: questionData[questionCounter].attachedFileURL)
                            }
                        }).padding(
                            .bottom)
                        if(questionData[questionCounter].attachedFileURL.contains(".jpeg") || questionData[questionCounter].attachedFileURL.contains(".jpg") || questionData[questionCounter].attachedFileURL.contains(".png")){
                            Image(nsImage: NSImage(contentsOfFile: questionData[questionCounter].attachedFileURL)!)
                                .resizable().frame(width: 200, height: 200).clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                        }else if(questionData[questionCounter].attachedFileURL.contains(".wav")){
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
                        if(!questionData[questionCounter].options.isEmpty){
                            ForEach(0..<questionData[questionCounter].options.count,id: \.self) { index in
                                Button(
                                    action: {
                                        answer = questionData[questionCounter].options[index]
                                    },
                                    label: {
                                        HStack{
                                            Image(systemName: answer == questionData[questionCounter].options[index] ? "inset.filled.circle" : "circle").foregroundStyle(answer == questionData[questionCounter].options[index] ? .blue : .gray)
                                            Text(questionData[questionCounter].options[index])
                                        }.font(.title2)
                                    }
                                ).padding(.bottom).buttonStyle(.plain).disabled(isReadyToSubmit).disabled(STARTQUIZ.isReview)
                            }
                        }else{
                            Text("Answer: ").font(.title3)
                            TextEditor(text: $answer).font(.title3).frame(
                                height: 150
                            ).scrollContentBackground(.hidden).overlay(content: {
                                RoundedRectangle(
                                    cornerRadius: 8, style: .continuous
                                ).stroke(.gray.opacity(0.3), lineWidth: 1)
                            }).disabled(isReadyToSubmit).disabled(STARTQUIZ.isReview)
                        }
                        if(STARTQUIZ.isReview){
                            Text("Correct Answer: ").font(.title3)
                            TextEditor(text: $correctAnswerIfReviewed).font(.title3).frame(height: 150).scrollContentBackground(.hidden).overlay(content: {
                                RoundedRectangle(cornerRadius: 8,style: .continuous).stroke(.gray.opacity(0.3), lineWidth: 1)
                            }).disabled(STARTQUIZ.isReview)
                        }
                        HStack {
                            if(!isReadyToSubmit){
                            if(questionCounter != 0){
                                Button("Previous"){
                                    isAllQuestionCompleted = false
                                    questionCounter -= 1
                                    answer = givenAnswers[questionCounter]
                                }.buttonStyle(.plain).padding()
                                    .overlay(content: {
                                        Capsule().stroke(lineWidth: 1)
                                            .foregroundStyle(.blue)
                                            .frame(height: 30)
                                    })
                            }
                            Spacer()
                                Button(!isAllQuestionCompleted ? "Next" : "Finish") {
                                //Code
                                
                                //Update for given answers
                                givenAnswers[questionCounter] = answer
                                
                                    if isAllQuestionCompleted {
                                        isReadyToSubmit = true
                                    }
                                
                                //increase question counter
                                if(questionCounter < questionData.count - 1){
                                    questionCounter += 1
                                    answer = ""
                                    
                                }else{
                                    isAllQuestionCompleted = true
                                }
                            }.buttonStyle(.plain).padding()
                                .overlay(content: {
                                    Capsule().stroke(lineWidth: 1)
                                        .foregroundStyle(.blue)
                                        .frame(height: 30)
                                })
                            }else{
                                Spacer()
                                Button(STARTQUIZ.isReview ? "Close" : "Submit"){
                                    //Submit and check
                                    if(!STARTQUIZ.isReview){
                                        isSubmitted = true
                                        checkAnswers()
                                    }else{
                                        ContentView.fileManager.updateBookmarks(course: STARTQUIZ.course,title: STARTQUIZ.title,desc: desc,bookmarkedQuestions: bookmarkedQuestionsSet)
                                        STARTQUIZ.isReview = false
                                        dismissWindow(id: "PractisePage")
                                    }
                                }.buttonStyle(.plain).padding().foregroundStyle(STARTQUIZ.isReview ? .red : .green)
                                    .overlay(content: {
                                        Capsule().stroke(lineWidth: 1)
                                            .foregroundStyle(STARTQUIZ.isReview ? .red : .green)
                                            .frame(height: 30)
                                    })
                            }
                        }.padding(.trailing).font(.title)
                        
                    }
                }
                    
                }
            }
            Spacer()
        }.padding()
    }
}



struct QuestionData: Identifiable {
    var id = UUID().uuidString
    var question: String
    var questionType: String
    var attachedFileURL: String
    var options: [String]
    var correctAnswer: String
    var points: Int
}
