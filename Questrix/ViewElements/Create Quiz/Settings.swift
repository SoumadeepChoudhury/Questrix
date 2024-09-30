//
//  Settings.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 21/09/24.
//

import SwiftUI

struct Settings: View {
    
    @Environment(\.colorScheme) var colorScheme

//    @Binding var isRandomAllowed: Bool
    @Binding var duration: String
//    @Binding var isUnlimitedRep: Bool
//    @Binding var isLimitedRep: Bool
//    @Binding var isNoRep: Bool
//    @Binding var limit: String
    @Binding var publishStatus: String
    @Binding var publishDate: Date
    
    

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings").font(.title).fontWeight(.semibold)
            Text("Set some extra details of your quiz.").font(
                .caption2)
            Divider()

        }
        //Duration , Repetition, Publishing Setting
        ScrollView {
            VStack(alignment: .leading) {
                //Randomization
//                GroupBox {
//                    HStack {
//                        Toggle(
//                            "Randomization of Questions",
//                            isOn: $isRandomAllowed)
//                    }
//                }
                
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
                        
                        //Repetition
//                        VStack(alignment: .leading) {
//                            Text("Repetition").font(.title2).padding(.bottom)
//                            Button(
//                                action: {
//                                    isUnlimitedRep = true
//                                    isLimitedRep = false
//                                    isNoRep = false
//                                },
//                                label: {
//                                    Image(systemName: !isUnlimitedRep ? "circle" : "inset.filled.circle").foregroundStyle(isUnlimitedRep ? .blue : (colorScheme == .light ? .black : .white))
//                                    Text("Unlimited Repetition")
//                                }
//                            ).buttonStyle(.plain)
//
//                            Button(
//                                action: {
//                                    isUnlimitedRep = false
//                                    isLimitedRep = true
//                                    isNoRep = false
//                                },
//                                label: {
//                                    Image(systemName: !isLimitedRep ? "circle" : "inset.filled.circle").foregroundStyle(isLimitedRep ? .blue : (colorScheme == .light ? .black : .white))
//                                    Text("Limited Repetition:")
//                                    TextField("$", text: $limit).disabled(!isLimitedRep).textFieldStyle(
//                                        .roundedBorder
//                                    ).frame(width: 50)
//                                }
//                            ).buttonStyle(.plain)
//
//                            Button(
//                                action: {
//                                    isUnlimitedRep = false
//                                    isLimitedRep = false
//                                    isNoRep = true
//                                },
//                                label: {
//                                    Image(systemName: !isNoRep ? "circle" : "inset.filled.circle").foregroundStyle(isNoRep ? .blue : (colorScheme == .light ? .black : .white))
//                                    Text("Single time - No Repetition")
//                                }
//                            ).buttonStyle(.plain)
//
//                        }.padding(.bottom)
//                        Divider()
                        
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
