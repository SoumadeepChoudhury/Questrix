//
//  Title.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct Title: View {
    
    @Binding var course: String
    @Binding var isTapped: Bool
    @State var isTappedOnAdded: Bool = false
    @State var courseName: String = ""
    
    var body: some View {
        HStack{
            Text("Courses").font(.largeTitle).fontWeight(.bold)
            Spacer()
            GroupBox{
                if(self.course == "" || !self.isTapped){
                    Image(systemName: "plus").font(.title)
                        .onTapGesture {
                            isTappedOnAdded.toggle()
                        }
                        .popover(isPresented: $isTappedOnAdded, arrowEdge: .leading, content: {
                            AddCourseView(courseName: $courseName)
                        })
                }
                else{
                    Text(self.course)
                }
            }.background(.thinMaterial)
        }.padding(.vertical)
    }
}
