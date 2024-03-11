//
//  GGLGoogleAI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/28/24.
//

import GoogleGenerativeAI

enum APIKey {
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
        }
        if value.starts(with: "_") {
            fatalError(
                "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
            )
        }
        return value
    }
}

struct GGLGoogleAI {
    static let shared = GGLGoogleAI()
    let chat: Chat

    init() {
        let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
        chat = model.startChat()
    }
}
