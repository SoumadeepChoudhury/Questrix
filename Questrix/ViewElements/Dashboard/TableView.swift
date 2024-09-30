//
//  TableView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 20/09/24.
//

import SwiftUI

struct TableView: View {
    
    @EnvironmentObject var USER: User
    
    var body: some View {
        GroupBox {
            HStack{
                VStack(alignment: .leading){
                    Text("Results").font(.title).fontWeight(.semibold)
                    Text("Latest 10 Results.").font(.caption2)
                }
                Spacer()
            }
            if(!USER.resultData.isEmpty){
                VStack {
                    HStack {
                        Spacer()
                        Text("Slno").font(.headline).frame(width:100)
                        Spacer()
                        Divider().frame(height: 30)
                        Spacer()
                        Text("Date").font(.headline).frame(width: 100)
                        Spacer()
                        Divider().frame(height: 30)
                        Spacer()
                        Text("Course/Title").font(.headline).frame(width: 100)
                        Spacer()
                        Divider().frame(height: 30)
                        Spacer()
                        Text("Total Points").font(.headline).frame(width: 100)
                        Spacer()
                        Divider().frame(height: 30)
                        Spacer()
                        Text("Points Acquired").font(.headline).frame(width: 100)
                        Spacer()
                    }
                    Divider()
                    ScrollView {
                        
                        ForEach(USER.resultData) { result in
                            HStack {
                                Spacer()
                                VStack {
                                    //Slno
                                    Text("\(result.slno)").frame(width: 100)
                                    Divider()
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                VStack {
                                    //Date
                                    Text("\(result.date)").frame(width: 100)
                                    Divider()
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                VStack {
                                    //Titles
                                    Text("\(result.title)")
                                        .lineLimit(1)
                                    Divider()
                                }.help(result.title) // Showing full text for truncations
                                Spacer()
                                Divider()
                                Spacer()
                                VStack {
                                    //Total Points
                                    Text("\(result.totalPoints)").frame(width: 100)
                                    Divider()
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                VStack {
                                    //Points Acquired
                                    Text("\(result.pointsAcquired)").frame(
                                        width: 100)
                                    Divider()
                                }
                                Spacer()
                                
                            }
                        }
                        Spacer()
                    }
                }
            }
            else{
                Text("No Result...")
            }
        }
    }
}

struct TableViewCell: View {
    var body: some View {
        Text("Helo")
    }
}

#Preview {
    TableView().frame(width: 600, height: 400)
}
#Preview {
    TableView().frame(width: 600, height: 400).preferredColorScheme(.light)
}
