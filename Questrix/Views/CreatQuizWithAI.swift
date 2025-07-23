//
//  CreatQuizWithAI.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/07/25.
//

import SwiftUI

struct CreateQuizWithAI: View {
    @EnvironmentObject var coursesArray: CoursesArray
    @State private var selectedCourse: String = "Select Course"
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var difficulty: String = "Medium"
    @State private var questionCount: Int = 5
    @State private var duration: String = ""
    @State var publishStatus: String = "Select..."
    @State var publishDate: Date = Date()
    @State private var isLoading: Bool = false
    @State private var generatedQuiz: [String: Any]?
    
    @State private var showErrorModal = false
    
    private let apiClient = GeminiAPI()
    
    @Environment(\.colorScheme) var colorScheme
    
    let difficulties = ["Easy", "Medium", "Hard"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("AI Quiz Generator")
                        .font(AppFonts.largeTitle)
                    
                    Text("Create quizzes instantly with AI")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Form
                VStack(spacing: 20) {
                    // Course Selection
                    HStack {
                        Spacer()
                        Menu(selectedCourse) {
                            ForEach(coursesArray.courses) { course in
                                Button(course.title) {
                                    selectedCourse = course.title
                                }
                            }
                        }   .padding(16)
                            .frame(width: 200, height: nil, alignment: .leading)
                            .background(AppColors.cardBackground(for: colorScheme))
                            .cornerRadius(AppShapes.mediumCornerRadius)
                        }
                    
                    // Quiz Details
                    VStack(spacing: 16) {
                        TextField("Quiz Title", text: $title)
                            .textFieldStyle(PremiumTextFieldStyle())
                        
                        TextField("Description", text: $description, axis: .vertical)
                            .textFieldStyle(PremiumTextFieldStyle())
                            .frame(minHeight: 80, maxHeight: 120)
                    }
                    
                    // Settings
                    VStack(spacing: 16) {
                        Picker("Difficulty", selection: $difficulty) {
                            ForEach(difficulties, id: \.self) { level in
                                Text(level)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Stepper(value: $questionCount, in: 3...20) {
                            HStack {
                                Text("Questions:")
                                Text("\(questionCount)")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding(16)
                    .background(AppColors.cardBackground(for: colorScheme))
                    .cornerRadius(AppShapes.mediumCornerRadius)
                    
                    
                    VStack(spacing: 16) {
                        HStack {
                            TextField("Duration", text: $duration)
                                .textFieldStyle(PremiumTextFieldStyle())
                                .textContentType(.postalCode)
                            Text("min")
                        }
                        
                        //Publishing Status
                        VStack(alignment: .leading) {
                            Text("Publishing Setting").font(.title2).padding(
                                .bottom)
                            Text("Publish Status:").font(.title3)
                            Menu(publishStatus) {
                                Button(
                                    action: {
                                        publishStatus = "Schedule"
                                    },
                                    label: {
                                        Text("Schedule")
                                    })

                                Button(
                                    action: {
                                        publishStatus = "Immediate"
                                    },
                                    label: {
                                        Text("Immediate")
                                    })
                            }.frame(width: 200)
                                .padding(.bottom)
                            
                            Text("Publish Date:")
                            
                            DatePicker(
                                "", selection: $publishDate, in:
                                    Date()...
                            ).datePickerStyle(StepperFieldDatePickerStyle()).disabled(publishStatus == "Immediate" ? true : false)

                    }.padding()
                    }
                    
                    // Generate Button
                    Button(action: generateQuiz) {
                        HStack {
                            if isLoading {
                                ProgressView()
                            } else {
                                Image(systemName: "sparkles")
                            }
                            Text("Generate Quiz")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isLoading || selectedCourse.isEmpty || title.isEmpty)
                }
                
                // Generated Quiz Preview
                if let quiz = generatedQuiz {
                    GeneratedQuizPreview(quiz: quiz)
                        .transition(.slide)
                }
            }
            .padding(20)
        }
            .background(AppColors.background(for: colorScheme))
        
            .overlay(
                        AIErrorModal(
                            isPresented: $showErrorModal,
                            errorMessage: "The AI service is currently overloaded. Please try again in a few minutes.",
                            retryAction: {
                                // Call your generate quiz function again
                                generateQuiz()
                            }
                        )
                        .opacity(showErrorModal ? 1 : 0)
                        .animation(.spring(), value: showErrorModal)
                    )
    }
    
    private func convertJSONStringToDictionary(_ jsonString: String) -> [String: Any]? {
        let _jsonString = jsonString.replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let jsonData = _jsonString.data(using: .utf8) else { return nil }
        do {
            return try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        } catch {
            print("JSON parsing error:", error)
            return nil
        }
    }

    
    private func generateQuiz() {
        if(selectedCourse.isEmpty || title.isEmpty || description.isEmpty || publishStatus == "Select..."){
            //show a error
            return
        }
        isLoading = true
    

        
        apiClient.sendMessage(course: selectedCourse, title: title, description: description, difficulty: difficulty, numberOfQuestions: questionCount) { response in
            DispatchQueue.main.async {
                let aiResponse = response ?? "No response"
                //Comvert jsonstring to dictionary
                if(aiResponse != "No response"){
                    guard
                        let dict = convertJSONStringToDictionary(aiResponse),
                              let questionData = dict["questionsData"] as? [[String: Any]] // key may vary (e.g. "questionData")
                        else {
                            print("Error extracting quiz info.")
                            return
                        }

                    generatedQuiz = [
                        "course": selectedCourse,
                        "title": title,
                        "description": description,
                        "difficulty": difficulty,
                        "questions": questionData,
                        "duration": Int(duration) ?? 0,
                        "publishDate": publishDate
                    ]
                    isLoading = false
                }else{
                    showErrorModal = true
                }
            }
        }
    }
   
}

struct GeneratedQuizPreview: View {
    let quiz: [String: Any]
    @State private var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Generated Quiz Preview")
                    .font(AppFonts.title2)
                
                Spacer()
                
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 20) {
                    Text("**Course:** \(quiz["course"] as? String ?? "")")
                    Text("**Title:** \(quiz["title"] as? String ?? "")")
                    Text("**Difficulty:** \(quiz["difficulty"] as? String ?? "")")
                    
                    Divider()
                    
                    ForEach(0..<(quiz["questions"] as? [[String: Any]] ?? []).count, id: \.self) { index in
                        if let question = (quiz["questions"] as? [[String: Any]])?[index] {
                            QuestionPreview(question: question, index: index + 1)
                        }
                    }
                }
                .padding(16)
                .background(AppColors.cardBackground(for: colorScheme))
                .cornerRadius(AppShapes.mediumCornerRadius)
            }
            
            HStack(spacing: 16) {
                Spacer()
                
                Button("Save Quiz") {
                    ContentView.fileManager.createQuiz(
                        course: quiz["course"] as? String ?? "",
                            title: quiz["title"] as? String ?? "",
                            description: quiz["description"] as? String ?? "",
                            questionData: quiz["questions"] as? [[String:Any]] ?? [["":""]],
                            duration: quiz["duration"] as? Int ?? 0,
                            publishDate: quiz["publishDate"] as? Date ?? Date()
                        )
                }
                .buttonStyle(PrimaryButtonStyle())
                .frame(width: 250)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(AppShapes.mediumCornerRadius)
    }
}

struct QuestionPreview: View {
    let question: [String: Any]
    let index: Int
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(index). \(question["question"] as? String ?? "")")
                .font(AppFonts.headline)
            
            (question["answer_options"] == nil) ? Text("Answer: \(question["correct_answer"] as? String ?? "")").font(AppFonts.caption) : nil
            
            ForEach(0..<(question["answer_options"] as? [String] ?? []).count, id: \.self) { optionIndex in
                HStack(spacing: 8) {
                    Image(systemName: "circle")
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    
                    Text((question["answer_options"] as? [String] ?? [])[optionIndex])
                    
                    if (question["answer_options"] as? [String] ?? [])[optionIndex] == (question["correct_answer"] as? String ?? "") {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
        }
    }
}
