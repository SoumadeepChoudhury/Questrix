//
//  Heading().swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 21/09/24.
//

import SwiftUI

struct Heading: View {
    
    @Binding var enterCourseToSaveAsDraft: Bool
    @Binding var step: Int
    @Binding var confirmSaveAsDraft: Bool
    
    var body: some View {
        HStack{
            Text("Create a Quiz").font(.largeTitle).fontWeight(.bold)
            Spacer()
            GroupBox{
                Text("Save As Draft").padding(.horizontal,10).padding(.vertical,5)
            }.background(.blue.opacity(0.2)).onTapGesture {
                ContentView.fileManager.isRefferedFromEdit = false
                if(step <= 2){
                    enterCourseToSaveAsDraft.toggle()
                }else{
                    confirmSaveAsDraft.toggle()
                }
            }
        }.padding(.vertical)
    }
}
