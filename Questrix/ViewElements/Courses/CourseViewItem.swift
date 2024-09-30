//
//  CourseViewItem.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct CourseViewItem: View {
    
    var title: String
    var drafts: Int
    var quizzes: Int
    var attempted: Int
    @State var isDeleted: Bool = false
    @State var isTappedOnDelete: Bool = false
    
    var body: some View {
        if(!isDeleted){
            GroupBox{
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: "book").font(.title)
                        Text(title).font(.title).fontWeight(.semibold).lineLimit(1).help(title)
                        Spacer()
                        Image(systemName: "trash").onTapGesture{
                            //Delete course
                            isTappedOnDelete.toggle()
                            
                        }
                        .alert("Are you sure to delete \(title)",isPresented: $isTappedOnDelete){
                            Button("Yes"){
                                isDeleted = ContentView.fileManager.deleteCourse(courseName: title)
                            }
                            Button("Cancel"){
                                isTappedOnDelete.toggle()
                            }
                        }
                    }.padding(.bottom)
                    Text("Drafts: \(drafts)")
                    Text("Quizzes: \(quizzes)")
                    Text("Attempted: \(attempted)")
                }.padding()
            }.background(.ultraThinMaterial)
        }
    }
}
