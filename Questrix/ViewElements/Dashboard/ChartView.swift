//
//  ChartView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @EnvironmentObject var USER: User
    
    var body: some View {
        GroupBox{
            HStack{
                VStack(alignment: .leading){
                    Text("Your Activity").font(.title).fontWeight(.semibold)
                    Text("Last 7 using days.").font(.caption2)
                }
                Spacer()
            }
            
            //Chart -> Foreach -> LineMark -> AreaMark
            Chart(USER.activityData.reversed()) {item in
                LineMark(x: .value("Date",item.type), y: .value("Number of Quizes",item.value))
                    .interpolationMethod(.catmullRom)
                
                AreaMark(x: .value("Date",item.type), y: .value("Number of Quizes",item.value))
                    .opacity(0.1)
                    .interpolationMethod(.catmullRom)
            }.chartYScale(domain: 0...(USER.MaxActivityYScale + .random(in: 1...5)))
        }.frame(maxHeight:250)
    }
}
