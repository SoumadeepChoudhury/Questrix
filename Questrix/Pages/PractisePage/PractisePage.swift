//
//  PractisePage.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 26/09/24.
//

import SwiftUI

struct PractisePage: View {
    
    @Environment(\.dismissWindow) var dismissWindow
    @State var desc: String = ""
    @State var questionData: [QuestionData] = []
    @State var questionCounter: Int = 0
    @State var givenAnswers: [String] = []
    @State var isSubmitted: Bool = false
    
    var body: some View {
        if !isSubmitted {
            HStack{
                
                QuestionPreviewBar(desc: $desc,questionData: $questionData,questionCounter: $questionCounter,givenAnswers: $givenAnswers).frame(width: 200)
                Divider()
                DetailBar(desc: $desc,questionData: $questionData,questionCounter: $questionCounter,givenAnswers: $givenAnswers,isSubmitted: $isSubmitted)
                
            }.background(VisualEffectView().ignoresSafeArea())
        } else {
            let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
            //Submitted View
            VStack{
                ProgressView()
                Text("Evaluating...")
            }.onReceive(timer, perform: { _ in
                dismissWindow(id: "PractisePage")
            })
        }
    }
}

#Preview {
    PractisePage().frame(width: 800,height: 600)
}

#Preview {
    PractisePage().preferredColorScheme(.light)
}

