//
//  CompletionRequest.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/04.
//

// Request models
struct CompletionRequest: Codable {
    var model: String = "gpt-4o"
    var stream: Bool = false
    var messages: [Message]
}

struct Message: Codable {
    var role: Role
    var content: [MessageContent]
}

struct MessageContent: Codable {
    var type: ContentType
    var text: String?
    var imageUrl: ImageContent?
    
    init(imageUrl: String) {
        self.type = .image
        self.text = nil
        self.imageUrl = ImageContent(url: imageUrl)
//        self.imageUrl = ImageContent(url: "https://upload.wikimedia.org/wikipedia/commons/e/eb/Machu_Picchu%2C_Peru.jpg")
    }
    
    init(text: String) {
        self.type = .text
        self.text = text
        self.imageUrl = nil
    }
}

enum ContentType: String, Codable{
    case text = "text"
    case image = "image_url"
}

struct ImageContent: Codable {
    var url: String
}


enum Role: String, Codable {
    case user
    case assistant
    case system
}
