//
//  QuestionBox.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 21/09/24.
//

import SwiftUI
import AVFAudio

struct QuestionBox: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var questionCounter: Int
    @Binding var course: String
    @Binding var title: String
    @Binding var question: String
    @Binding var points: String
    @State var questionType: String = "Select..."
    @State var answerType: String = "Select..."
    @Binding var correctAnswer: String
    @Binding var attachedFileURL: String
    @Binding var isFileAttached: Bool
    @Binding var isMCQ: Bool
    @Binding var options: [String]
    
    
    @State var optionIndex: Int = 0
    @State var isTappedOnAddOption: Bool = false
    @State var isTappedOnDelete: Bool = false
    @State var optionToBeDeleted: String = ""
    @State var additionFileIconName = "waveform"
    @State var RECORDER: Recorder = Recorder()
    @State var AUDIOPLAYER:AudioPlayer = AudioPlayer(filePath: "")
//    let x = RecPlay()

    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                Text("Question \(questionCounter)").font(.title2).padding(.bottom).onChange(of: questionCounter, {
                    questionType = "Select..."
                    answerType = "Select..."
                    AUDIOPLAYER.stopEngine()
                })
                ScrollView {
                    VStack(alignment: .leading){
                        Text("Question: ").font(.title3)
                        HStack(alignment: .top) {
                            TextField("Enter you question here...", text: $question)
                                .textFieldStyle(.roundedBorder).padding(.bottom)
                            if questionType != "Text Based Question"
                                && questionType != "Select..."
                            {
                                
                                GroupBox {
                                    Image(
                                        systemName: questionType
                                        == "Image Based Question"
                                        ? "photo" : additionFileIconName
                                    ).onAppear(perform: {
                                        if(additionFileIconName == "waveform"){
                                            RECORDER = Recorder(filePath: ContentView.fileManager.masterDirectory.path + "/\(course)/.\(title)_audio_\(questionCounter).wav")
                                            additionFileIconName = "waveform"
                                        }
                                    }).onTapGesture {
                                        //File Attachment
                                        
                                        if(questionType == "Image Based Question"){
                                            let openPanel = NSOpenPanel()
                                            openPanel.prompt = "Select File"
                                            openPanel.allowsMultipleSelection = false
                                            openPanel.canChooseDirectories = false
                                            openPanel.canCreateDirectories = false
                                            openPanel.canChooseFiles = true
                                            openPanel.allowedContentTypes = [.png, .jpeg]
                                            openPanel.begin { (result) -> Void in
                                                if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                                                    attachedFileURL = openPanel.url!.path
                                                }
                                            }
                                        }else{
                                           
                                            do{
                                                if(additionFileIconName == "waveform.slash"){
                                                    //stop recording
                                                    RECORDER.stop()
                                                    attachedFileURL = ContentView.fileManager.masterDirectory.path + "/\(course)/.\(title)_audio_\(questionCounter).wav"
                                                    AUDIOPLAYER = AudioPlayer(filePath: attachedFileURL)
                                                    additionFileIconName = "play.circle"
                                                }else if(additionFileIconName == "pause.circle"){
                                                    //pause
                                                    AUDIOPLAYER.pause()
                                                    additionFileIconName = "play.circle"
                                                }else if(additionFileIconName == "play.circle"){
                                                    //play
                                                    AUDIOPLAYER.play()
                                                    additionFileIconName = "pause.circle"
                                                }
                                                else{
                                                    //start recording
                                                    RECORDER.start()
                                                    additionFileIconName = "waveform.slash"
                                                }
                                            }catch{
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }.help(questionType != "Image Based Question" ? (additionFileIconName == "waveform" ? "Start Recording" : "Stop recording") : "Insert Image")
                                }
                            }
                        }
                        //Display File
                        if(!attachedFileURL.isEmpty && !attachedFileURL.contains(".wav")){
                            let _ = print(attachedFileURL)
                            Image(nsImage: NSImage(contentsOfFile: attachedFileURL)!).resizable().frame(width: 100,height: 100).clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Question Type: ").font(.title3)
                                Menu(questionType) {
                                    Button(
                                        action: {
                                            questionType = "Text Based Question"
                                            isFileAttached = false
                                        },
                                        label: {
                                            Text("Text Based Question")
                                        })
                                    Button(
                                        action: {
                                            questionType = "Image Based Question"
                                            isFileAttached = true
                                        },
                                        label: {
                                            Text("Image Based Question")
                                        })
                                    Button(
                                        action: {
                                            questionType = "Voice Based Question"
                                            isFileAttached = true
                                        },
                                        label: {
                                            Text("Voice Based Question")
                                        })
                                }
                                
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Answer Type:").font(.title3)
                                Menu(answerType) {
                                    Button(
                                        action: {
                                            answerType =
                                            "Multiple Choice Question (MCQ)"
                                            isMCQ = true
                                        },
                                        label: {
                                            Text("Multiple Choice Question (MCQ)")
                                        })
                                    Button(
                                        action: {
                                            answerType = "Type Answer - Question"
                                        },
                                        label: {
                                            Text("Type Answer - Question")
                                        })
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Set Points:").font(.title3)
                                TextField("Points...", text: $points)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }.padding(.bottom)
                        if answerType == "Multiple Choice Question (MCQ)" {
                            
                            HStack(alignment: .top) {
                                GroupBox {
                                    VStack(alignment: .leading) {
                                        Text("Answer Options: ").font(.title3)
                                        Divider()
                                        
                                        ForEach($options,id: \.self){ $opt in
                                            
                                            HStack {
                                                Image(systemName: "circle")
                                                TextField("New Option", text: $opt)
                                                    .textFieldStyle(.roundedBorder).disabled(true)
                                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                                Image(systemName: "minus.circle").onTapGesture(perform: {
                                                    isTappedOnDelete.toggle();
                                                    optionToBeDeleted = opt
                                                })
                                                .alert("Are You Sure? Delete: \(optionToBeDeleted)", isPresented: $isTappedOnDelete){
                                                    Button("Yes"){
                                                        options.remove(at: options.firstIndex(of: optionToBeDeleted)!)
                                                    }
                                                    Button("No"){
                                                        isTappedOnDelete.toggle()
                                                    }
                                                }
                                            }.padding(.bottom)
                                            
                                        }
                                        
                                        
                                        Button(
                                            action: {
                                                isTappedOnAddOption.toggle()
                                            },
                                            label: {
                                                Text("Add Options")
                                            }
                                        ).backgroundStyle(.ultraThinMaterial)
                                            .alert("Add option",isPresented: $isTappedOnAddOption){
                                                AddOptionView(options: $options)
                                            }
                                        
                                    }
                                }
                                GroupBox {
                                    VStack(alignment: .leading) {
                                        Text("Correct Option:").font(.title3)
                                        Menu(correctAnswer == "" ? "Select..." : correctAnswer) {
                                            ForEach(options,id: \.self){ option in
                                                Button(
                                                    action: {
                                                        correctAnswer = option
                                                    },
                                                    label: {
                                                        Text(option)
                                                    })
                                            }
                                        }
                                    }
                                }
                            }
                        } else if answerType == "Type Answer - Question" {
                            VStack(alignment: .leading) {
                                
                                Text("Correct Answer").font(.title3)
                                TextEditor(
                                    text: $correctAnswer
                                ).frame(height: 200)
                                    .scrollContentBackground(.hidden)
                                    .font(.title3)
                                    .overlay(content: {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous).stroke((colorScheme == .dark ? Color.white : Color.black).opacity(0.3) , lineWidth: 1)
                                    })
                            }
                        }
                        
                    }
                }
            }
        }
    }
}


struct AddOptionView: View {
    @State var text: String = ""
    @Binding var options: [String]
    var body: some View {
        Text("Option:")
        TextField("Option",text: $text)
        Button("Add"){
            if(!options.contains(text)){
                options.append(text)
            }
        }
    }
}
