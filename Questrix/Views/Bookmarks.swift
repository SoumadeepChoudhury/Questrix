//
//  Bookmarks.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 19/09/24.
//

import SwiftUI

struct Bookmarks: View {
    
    @EnvironmentObject var BOOKMARK: BookmarkData
    
    @State var selectedCourse: String = "Select..."
    @State var search: String = ""
    @State var coursesPresent: [String] = []
    
    
    
/*
 Bookmark(id: "D8CFBFD0-E6A8-485A-BB36-30D292531710", course: "Spanish", title: "Quiz 1", decripton: "", questionData: [])
 Bookmark(id: "4F336D51-115B-464E-A339-1B25106192E9", course: "English", title: "Quiz 1", decripton: "", questionData: [])
 Bookmark(id: "F9DE4319-F4F5-4B3B-9F39-BC2EC40FA4A3", course: "Spanish", title: "Quiz 2", decripton: "", questionData: [])
 */
    
    var body: some View {
        VStack{
            //DateTime
            DateTime().onAppear(perform: {
                ContentView.fileManager.getBookmarks(BOOKMARK: BOOKMARK)
                BOOKMARK.bookmarks.forEach({ item in
                    if !coursesPresent.contains(item.course){
                        coursesPresent.append(item.course)
                    }
                })
            })
            
            //Title
            BookmarkTitle(course: $selectedCourse,coursesPresent: $coursesPresent)
            
            if(!BOOKMARK.bookmarks.isEmpty){
                ScrollView{
                    VStack(alignment: .leading){
                        ForEach(selectedCourse == "Select..." ? 0..<coursesPresent.count : 0..<1, id: \.self){ courseIndex in
                            if(selectedCourse == "Select..."){
                                Text(coursesPresent[courseIndex]).font(.title).fontWeight(.semibold)
                                Divider()
                            }else{
                                GroupBox{
                                    HStack{
                                        Image(systemName: "magnifyingglass")
                                        TextField("Search",text: $search).textFieldStyle(PlainTextFieldStyle())
                                    }
                                }
                            }
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 180))]){
                                ForEach(BOOKMARK.bookmarks){ bMark in
                                    if(!search.isEmpty){
                                        if(bMark.title.contains(search) && bMark.course == selectedCourse){
                                            BookmarkItem(course: bMark.course,title: bMark.title, bookmarked: bMark.questionData.count,bookmarkedQuestions: bMark.questionData)
                                        }
                                    }else{
                                        if(bMark.course == (selectedCourse == "Select..." ? coursesPresent[courseIndex] : selectedCourse)){
                                            BookmarkItem(course: bMark.course,title: bMark.title,bookmarked: bMark.questionData.count,bookmarkedQuestions: bMark.questionData)
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }else{
                Spacer()
                Image(systemName: "hockey.puck").resizable().frame(width:300,height: 300).opacity(0.1)
            }
            
            Spacer()
        }.padding()
    }
}

#Preview {
    Bookmarks()
}
