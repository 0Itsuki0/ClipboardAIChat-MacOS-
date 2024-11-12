//
//  APIErrorResponse.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/04.
//

// Error response
struct APIErrorResponse: Error, Codable {
    public let error: APIError
}

struct APIError: Codable {
    public let message: String
    public let type: String
    public let param: String?
    public let code: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let string = try? container.decode(String.self, forKey: .message) {
          self.message = string
        } else if let array = try? container.decode([String].self, forKey: .message) {
          self.message = array.joined(separator: "\n")
        } else {
          throw DecodingError.typeMismatch(String.self, .init(codingPath: [CodingKeys.message], debugDescription: "message: expected String or [String]"))
        }
        
        self.type = try container.decode(String.self, forKey: .type)
        self.param = try container.decodeIfPresent(String.self, forKey: .param)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
    }
}
