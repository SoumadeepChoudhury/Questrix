//
//  ApiView.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 16/07/25.
//


import SwiftUI

struct ApiView: View {
    @State private var userInput = ""
    @State private var aiResponse = ""
    private let apiClient = GeminiAPI()

    var body: some View {
        VStack {
            TextField("Ask Gemini...", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Send") {
                apiClient.sendMessage(userInput: userInput) { response in
                    DispatchQueue.main.async {
                        aiResponse = response ?? "No response"
                    }
                }
            }
            .padding()

            Text("Gemini says:")
                .font(.headline)
                .padding(.top)
            Text(aiResponse)
                .padding()
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding()
    }
}


#Preview {
    ApiView()
}
