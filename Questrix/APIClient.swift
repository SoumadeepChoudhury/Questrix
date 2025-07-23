//
//  APIClient.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 16/07/25.
//

import Foundation

class GeminiAPI {
    private let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    private let apiKey = Secrets.aiAPIKey

    func sendMessage(course: String,title:String, description: String,difficulty: String,numberOfQuestions: Int, completion: @escaping (String?) -> Void) {
        // Build URL with API key as query parameter
        guard var components = URLComponents(string: endpoint) else {
            completion("Invalid endpoint")
            return
        }
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]

        guard let url = components.url else {
            completion("Failed to build URL")
            return
        }
        
        let prompt = """
        Create a quiz based on the following details.

        Course: \(course)
        Title: \(title)
        Description: \(description)
        Difficulty: \(difficulty)
        Number of Questions: \(numberOfQuestions)

        Each question should be either:
        - A simple text question with a text-based correct answer.
        - Or a multiple-choice question (MCQ) with a list of answer options and one correct option.

        The output format should strictly follow this Swift structure and be returned in JSON:

        struct QuizData: Identifiable {
            let questionsData: [[String: Any]] // Array of questions
        }

        Each item in `questionsData` should look like this:
        - For text answer type:
          { "question": "What is ...?", "correct_answer": "Answer", "points": "5" }

        - For MCQ:
          {
            "question": "Which of the following is ...?",
            "answer_options": ["Option A", "Option B", "Option C", "Option D"],
            "correct_answer": "Option B",
            "points": "5"
          }

        ⚠️ IMPORTANT:
        - Return the entire `QuizData` object as a single JSON.
        - Keep `duration` realistic based on the number of questions (e.g. 1 min/question).
        - Use today's date in ISO format for `releaseDate`.
        - Do not include Swift code — just JSON.

        Now generate the full quiz as described.
        """

        // Build request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Build JSON body
        let requestBody = GeminiRequest(
            contents: [
                .init(parts: [.init(text: prompt)])
            ]
        )

        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch {
            print("Encoding error: \(error)")
            completion("Encoding error")
            return
        }

        // Make network call
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion("Network error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion("No HTTP response")
                return
            }

            print("Status Code: \(httpResponse.statusCode)")

            guard (200...299).contains(httpResponse.statusCode), let data = data else {
                if let data = data, let raw = String(data: data, encoding: .utf8) {
                    print("Raw error response: \(raw)")
                    completion("Error: \(raw)")
                } else {
                    completion("HTTP Error: \(httpResponse.statusCode)")
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
                let reply = decoded.candidates.first?.content.parts.first?.text
                completion(reply ?? "No response")
            } catch {
                print("Decoding error: \(error)")
                completion("Decoding error")
            }
        }

        task.resume()
    }
}
