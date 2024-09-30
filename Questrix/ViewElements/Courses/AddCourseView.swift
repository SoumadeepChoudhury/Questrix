//
//  AddCourseView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 22/09/24.
//

import SwiftUI

struct AddCourseView: View {
    
    @Binding var courseName: String
    @State var alertTitle: String = ""
    @State var isAlertShown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Course Name: ").font(.title3).fontWeight(.semibold)
                TextField("Course Name...",text: $courseName).textFieldStyle(.roundedBorder)
            }
            HStack{
                Spacer()
                Button(action:{
                    if(!courseName.isEmpty){
                        let returnVal: String = ContentView.fileManager.createCourses(courseName: courseName)
                        if(returnVal == "Exist"){
                            isAlertShown = true
                            alertTitle = "Course already exists."
                        }else if(returnVal == "Error"){
                            isAlertShown = true
                            alertTitle = "Some internal error occured. Try again."
                        }else if(returnVal == "Created"){
                            isAlertShown = false
                            courseName = ""
                        }
                    }else{
                        isAlertShown = true
                        alertTitle = "Empty course name."
                    }
                },label: {
                    Text("Add Course")
                }).background(.thinMaterial).alert(alertTitle, isPresented: $isAlertShown, actions: {
                    Button("Cancel"){
                        isAlertShown = false
                        alertTitle = ""
                    }
                })
            }
        }.padding()
    }
}

