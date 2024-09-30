//
//  CourseData.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct CourseData: Identifiable {
    let id = UUID().uuidString
    let title: String
    var drafts: Int
    var quizzes: Int
    var attempted: Int
}


class CoursesArray: ObservableObject {
    @Published var courses: [CourseData] = []
}
