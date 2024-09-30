//
//  Courses.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 19/09/24.
//

import SwiftUI

struct Courses: View {
    @EnvironmentObject var COURSEARRAY: CoursesArray
    
    @State var isTapped: Bool = false
    @State var courseTitle: String = ""
    @Binding var selectedTab: String
//    @State var drafts: Int = .zero
//    @State var quizzes: Int = .zero
//    @State var attempted: Int = .zero
    
    var body: some View {
        VStack{
            //DateTime
            DateTime()
            
            //Title
            Title(course: $courseTitle,isTapped: $isTapped)
            
            //Course Items
            if(!isTapped){
                if(!COURSEARRAY.courses.isEmpty){
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 180))],spacing: 40){
                            ForEach(COURSEARRAY.courses){ course in
                                CourseViewItem(title: course.title, drafts: course.drafts, quizzes: course.quizzes, attempted: course.attempted)
                                    .onTapGesture(perform: {
                                        self.isTapped = true
                                        self.courseTitle = course.title
//                                        self.drafts = course.drafts
//                                        self.quizzes = course.quizzes
//                                        self.attempted = course.attempted
                                    })
                            }
                        }
                    }
                }else {
                    Spacer()
                    Image(systemName: "hockey.puck").resizable().frame(width: 300,height: 300).opacity(0.2)
                }
            }
            else {
                CourseItemDetailView(courseTitle: self.courseTitle, isTapped: $isTapped,selectedTab: $selectedTab)
            }
            Spacer()
        }.padding()
    }
}

//#Preview {
//    Courses()
//}
//
//#Preview {
//    Courses().preferredColorScheme(.light)
//}
