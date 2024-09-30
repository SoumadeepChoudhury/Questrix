//
//  BookmarkData.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 28/09/24.
//

import Foundation

struct Bookmark: Identifiable {
    let id = UUID().uuidString
    let course: String
    let title: String
    var questionData: [[String:Any]]
}

class BookmarkData: ObservableObject {
    @Published var bookmarks: [Bookmark] = []
}
