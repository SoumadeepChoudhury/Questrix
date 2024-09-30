//
//  Dashboard.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 19/09/24.
//

import SwiftUI



struct Dashboard: View {
    
    var body: some View {
        
        VStack {
            
            //DateTime
            DateTime()
            
            //Title -> Intro and Acccount Points
            IntroductoryTitle()
            
            //Course, Total Quizzes created, Total quizzes attempted
            ContentOverview()
            
            //Charts -> UserActivity
            ChartView()
            
            //TableView -> Latest Results
            TableView()
            
            Spacer()
        
        }.padding()
        
    }
}




#Preview {
    Dashboard()
    
}

#Preview {
    Dashboard().preferredColorScheme(.light)    
}
