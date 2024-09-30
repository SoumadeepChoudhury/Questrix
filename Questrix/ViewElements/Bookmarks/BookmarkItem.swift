//
//  BookmarkItem.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 22/09/24.
//

import SwiftUI

struct BookmarkItem: View {
    @Environment(\.openWindow) var openWindow
    @EnvironmentObject var STARTQUIZ: StartQuiz
    
    var course: String
    var title: String
    var bookmarked: Int
    var bookmarkedQuestions: [[String:Any]]
    
    var body : some View {
        GroupBox{
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "document.on.document").font(.title)
                    Text(title).font(.title).fontWeight(.semibold).lineLimit(1).help(title)
                }.padding(.bottom)
                Text("Bookmarked: \(bookmarked)")
            }.padding()
            Button(action: {
                //Open Bookmark question preview
                STARTQUIZ.course = course
                STARTQUIZ.title = title
                STARTQUIZ.questionData = bookmarkedQuestions
                openWindow(id: "BookMarkPreview")
            }, label: {
                Text("View Questions")
            })
            .foregroundStyle(.blue)
            .buttonStyle(.borderless)
            .overlay(content: {
                Capsule().stroke(lineWidth: 1)
                    .foregroundStyle(.blue)
                    .frame(width: 130,height: 20)
            })
        }.frame(minWidth: 130)
    }
}

