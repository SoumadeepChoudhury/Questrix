//
//  IntroductoryTitle.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct IntroductoryTitle: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var USER: User
    
    var body: some View {
        HStack{
            
            //Title
            VStack(alignment: .leading){
                Text("Hi, \(USER.UserName.split(separator: " ")[0])!").font(.largeTitle).fontWeight(.bold)
                Text("Nice to have you back, what an Exciting day!\nGet Ready and continue your practise.").font(.title3).foregroundColor(.secondary)
            }
            Spacer()
            
            //Points
            GroupBox{
                HStack{
                    Text("Your Points: ").font(.title2).fontWeight(.semibold)
                    Text("\(USER.MyPoints)").fontWeight(.bold).font(.title2)
                }
            }
            .background((colorScheme == .dark ? Color.gray : Color.white)
                .opacity(0.45)
                .cornerRadius(20)
                .shadow(color: .black, radius: 6, x: 0, y: 3)
                .blur(radius: 8, opaque: false))
                
            
        }
    }
}
