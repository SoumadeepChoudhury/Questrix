//
//  QuizData.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct QuizData:Identifiable {
    let id = UUID().uuidString
    let course: String
    let title: String
    let description: String
    let duration: Int
    let releaseDate: Date
    let questionsData: [[String:Any]]
    var isAttempted: Bool = false
    var isDrafted: Bool = false
}

class QuizArray: ObservableObject {
    @Published var quizzes: [QuizData] = []
}


class StartQuiz: ObservableObject {
    @Published var course: String = ""
    @Published var title: String = ""
    @Published var isReAttempt: Bool = false
    @Published var isReview: Bool = false
    @Published var questionData: [[String:Any]] = []
}
