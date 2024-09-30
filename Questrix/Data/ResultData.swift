//
//  ResultData.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct ResultData: Identifiable {
    let id = UUID().uuidString
    let slno: Int
    let title: String
    let date: String
    let totalPoints: Int
    let pointsAcquired: Int
}

