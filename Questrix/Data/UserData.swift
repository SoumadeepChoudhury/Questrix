//
//  ActivityData.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//
import Foundation

struct UserActivity: Identifiable {
    let id = UUID().uuidString
    let type: String
    let value: Int
}

var sample: [UserActivity] = [
    UserActivity(type: "20 Sep", value: .random(in: 0...24)),
    UserActivity(type: "21 Sep", value: .random(in: 0...24)),
    UserActivity(type: "22 Sep", value: .random(in: 0...24)),
    UserActivity(type: "23 Sep", value: .random(in: 0...24)),
    UserActivity(type: "24 Sep", value: .random(in: 0...24)),
    UserActivity(type: "25 Sep", value: .random(in: 0...24)),
    UserActivity(type: "26 Sep", value: .random(in: 0...24))
]


class User: ObservableObject {
    @Published var UserName: String = "User"
    @Published var MyPoints: Int = 0
    @Published var resultData: [ResultData] = []
    @Published var activityData: [UserActivity] = []
    @Published var MaxActivityYScale: Int = 0
}

class QuizResultData: ObservableObject {
    @Published var Course: String = ""
    @Published var Title: String = ""
    @Published var DateAttempted: Date = Date()
    @Published var PointsScored: Int = 0
    @Published var TotalPoints: Int = 0
}
