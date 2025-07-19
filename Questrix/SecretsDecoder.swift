//
//  SecretsDecoder.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 16/07/25.
//

import Foundation

enum Secrets {
    static var aiAPIKey: String {
        guard let key = Bundle.main.infoDictionary?["AI_API_KEY"] as? String else{
            fatalError("API KEY not found");
        }
        return key
    }
}
