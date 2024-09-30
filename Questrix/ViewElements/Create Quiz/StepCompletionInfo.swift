//
//  StepCompletionInfo.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 21/09/24.
//

import SwiftUI

struct StepCompletionInfo: View {
    
    @Binding var step: Int
    
    var body: some View {
        
        VStack{
            HStack{
                Text("Select Course").frame(width: 120)
                Text("Basic Info").frame(width: 130)
                Text("Add Questions").frame(width: 150)
                Text("Settings").frame(width: 100)
            }
            
            HStack{
                Image(systemName: step >= 1 ? "inset.filled.circle" : "circle").font(.title)
                Rectangle().frame(width: 100,height: 2)
                Image(systemName: step >= 2 ? "inset.filled.circle" : "circle").font(.title)
                Rectangle().frame(width: 100,height: 2)
                Image(systemName: step >= 3 ? "inset.filled.circle" : "circle").font(.title)
                Rectangle().frame(width: 100,height: 2)
                Image(systemName: step >= 4 ? "inset.filled.circle" : "circle").font(.title)
            }
        }.padding(.bottom)
    }
}
