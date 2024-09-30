//
//  Settings.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 21/09/24.
//

import SwiftUI

struct Settings: View {
    
    @Environment(\.colorScheme) var colorScheme

    @Binding var duration: String
    @Binding var publishStatus: String
    @Binding var publishDate: Date
    
    

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings").font(.title).fontWeight(.semibold)
            Text("Set some extra details of your quiz.").font(
                .caption2)
            Divider()

        }
        //Duration , Publishing Setting
        ScrollView {
            VStack(alignment: .leading) {
                
                GroupBox {
                    VStack(alignment: .leading) {
                        
                        //Duration
                        HStack {
                            Text("Duration").font(.title2)
                            TextField("Enter duration...", text: $duration).textContentType(.postalCode)
                                .textFieldStyle(.roundedBorder).frame(
                                    width: 150)
                            Text("min")
                        }.padding(.bottom)
                        Divider()
                        
                        //Publishing Status
                        VStack(alignment: .leading) {
                            Text("Publishing Setting").font(.title2).padding(
                                .bottom)
                            Text("Publish Status:").font(.title3)
                            Menu(publishStatus) {
                                Button(
                                    action: {
                                        publishStatus = "Schedule"
                                    },
                                    label: {
                                        Text("Schedule")
                                    })

                                Button(
                                    action: {
                                        publishStatus = "Immediate"
                                    },
                                    label: {
                                        Text("Immediate")
                                    })
                            }.frame(width: 200)
                                .padding(.bottom)
                            Text("Publish Date:")
                            DatePicker(
                                "", selection: $publishDate, in: Date()...
                            ).datePickerStyle(StepperFieldDatePickerStyle()).disabled(publishStatus == "Immediate" ? true : false)

                        }
                    }.padding()
                }.frame(maxWidth: 500).padding(.bottom)
            }
        }

    }
}
//}
