//
//  BasicInfo.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 21/09/24.
//

import SwiftUI

struct BasicInfo: View {
    
    @Binding var title: String
    @Binding var description: String
    
    var body: some View {
        GroupBox{
            VStack(alignment: .leading){
                Text("Basic Info").font(.title).fontWeight(.semibold)
                Text("Add basic info for the quiz.").font(.caption2)
                Divider()
                HStack{
                    Text("Title: ").font(.title2)
                    TextField("Enter title of the quiz",text: $title).textFieldStyle(.roundedBorder).disabled(ContentView.fileManager.isRefferedFromEdit ? true : false)
                }.padding(.bottom)
                HStack{
                    Text("Description: ").font(.title2)
                    TextField("Enter description of the quiz (Optional)",text: $description).textFieldStyle(.roundedBorder)
                }
            }.padding()
        }.padding(.vertical)
    }
}
