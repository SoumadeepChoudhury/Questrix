//
//  SelectCourse.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 21/09/24.
//

import SwiftUI

struct SelectCourse: View {
    
    @EnvironmentObject var coursesArray: CoursesArray
    @Binding var selectedCourse: String
    
    var body: some View {
        HStack{
            Text("Course: ").font(.title2)
            Menu(selectedCourse) {
                ForEach(coursesArray.courses){ course in
                    Button(action: {
                        selectedCourse = course.title
                    }) {
                        Text(course.title)
                    }.buttonStyle(.borderless)
                }
            }.font(.title).frame(width: 200).disabled(ContentView.fileManager.isRefferedFromEdit ? true : false)
        }
    }
}
