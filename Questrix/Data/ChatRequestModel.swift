//
//  ChatRequestModel.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 16/07/25.
//

import Foundation

struct GeminiRequest: Codable {
    struct Part: Codable {
        let text: String
    }
    struct Content: Codable {
        let parts: [Part]
    }
    let contents: [Content]
}
