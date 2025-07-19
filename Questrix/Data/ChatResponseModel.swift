//
//  ChatResponseModel.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 16/07/25.
//

import Foundation

struct GeminiResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            struct Part: Codable {
                let text: String
            }
            let parts: [Part]
        }
        let content: Content
    }
    let candidates: [Candidate]
}
