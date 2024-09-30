//
//  BookmarkTitle.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 22/09/24.
//

import SwiftUI

struct BookmarkTitle: View {
    
    @Binding var course: String
    @Binding var coursesPresent: [String]
    
    var body: some View {
        HStack {
            Text("Bookmarks").font(.largeTitle).fontWeight(.bold)
            Spacer()
            Menu(course){
                ForEach(0..<coursesPresent.count,id: \.self){ courseIndex in
                    Button(action:{course = coursesPresent[courseIndex]},label:{
                        Text(coursesPresent[courseIndex])
                    })
                }
            }.frame(width: 150).background(.thinMaterial)
        }.padding(.vertical)
    }
}
