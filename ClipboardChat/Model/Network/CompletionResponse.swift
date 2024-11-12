//
//  CompletionResponse.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/06.
//


struct CompletionResponse: Codable, Identifiable {
    var id: String
    var choices: [CompletionChoice]
}

struct CompletionChoice: Codable {
    var index: Int
    var message: CompletionMessage
}

struct CompletionMessage: Codable {
    var role: Role
    var content: String
}

