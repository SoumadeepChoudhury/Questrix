//
//  DateTime.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 19/09/24.
//

import SwiftUI

struct DateTime: View{
    @State var dateTime:Date = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        
        HStack{
            Spacer()
            Text("\(dateTime.formatted(date:.abbreviated,time:.standard))")
                .onReceive(timer){ _ in dateTime = Date()}
        }       
        
    }
}
