//
//  ChatManager.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/04.
//

import SwiftUI


@Observable
class ChatManager {
    static let shared = ChatManager()
    
    @MainActor var chats: [ChatBlock] = []

    @MainActor var isProcessing: Bool = false
    
    private let url = "https://api.openai.com/v1/chat/completions"
    
    private var taskResults: [TaskResult] = []
    
    enum ServiceError {
        
        case general
        case timeout
        case emptyItems
        case emptyChoices
        case openAIError(String)
        
        var message: String {
            switch self {
            case .general:
                "Oops! Something went wrong while processing! Please try again!"
            case .timeout:
                "Time Out! Please check your network and try again!"
            case .emptyItems:
                "Clipboard items needed for pre-defined tasks!"
            case .emptyChoices:
                "Oops! AI comes back with an empty response!"
            case .openAIError(let message):
                message
            }
        }
    }
    

    func getTaskResult(_ id: TaskResult.ID) -> TaskResult? {
        return taskResults.first(where: { $0.id == id })
    }
    
    
    func sendCompletionRequest(task: AITask, items: [PasteboardItem]) async {
        let itemsCount = PasteboardItem.getItemsOverview(items)
        if (itemsCount.image == 0 && itemsCount.string == 0 && !task.isCustom) {
            setError(.emptyItems)
            return
        }

        startProcessing(task: task, itemsCount: itemsCount)
        
        guard let request = createRequest(task: task, items: items) else {
            print("error creating request")
            setError(.general)
            return
        }
        var data: Data!
        var response: URLResponse!

        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch(let error) {
            print(error)
            setError(.timeout)
            return
        }
        
        print(response as Any)
        
        let decoder = JSONDecoder()
        let completionResponse: CompletionResponse!
        do {
            completionResponse = try decoder.decode(CompletionResponse.self, from: data)
            guard let text = completionResponse.choices.first?.message.content else {
                print("no choice available")
                setError(.emptyChoices)
                return
            }
            finishProcessing(task: task, items: items, message: text)
        } catch(let error) {
            print(error)
            if let decodedError = try? decoder.decode(APIErrorResponse.self, from: data) {
                setError(.openAIError(decodedError.error.message.isEmpty ? "Something went wrong with OpenAI" : decodedError.error.message))
            } else {
                setError(.general)
            }
            return
        }
    }
    
    private func setError(_ error: ServiceError) {
        DispatchQueue.main.async {
            self.isProcessing = false
            self.chats.append(.error(error.message))
        }
    }
    
    private func startProcessing(task: AITask, itemsCount: (string: Int, image: Int, other: Int)) {
        DispatchQueue.main.async {
            self.isProcessing = true
            var instruction = "**\(itemsCount.string)** text block(s) and **\(itemsCount.image)** images(s) sent \(task.name.isEmpty ? "with *\(task.prompt)* prompt" : "for **\(task.name)** task")."
            if itemsCount.other > 0 {
                instruction = "\(instruction) **\(itemsCount.other)** unsupported items ignored."
            }
            self.chats.append(.instruction(instruction))
        }
    }
    
    private func finishProcessing(task: AITask, items: [PasteboardItem], message: String) {
        print("task \(task.name) finished. \(message)")
        DispatchQueue.main.async {
            self.isProcessing = false
            let result = TaskResult(task: task, items: items, message: message)
            self.chats.append(.result(result))
            self.taskResults.append(result)
        }
    }
    
    
    private func createRequest(task: AITask, items: [PasteboardItem]) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        
        let contents = PasteboardItem.toContents(items)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaultsManager.shared.apiKey)",
            "Accept": "*/*"
        ]
        request.allHTTPHeaderFields = headers
        
        var messages: [Message] = [
            Message(
                role: task.isCustom ? .user : .system,
                content: [.init(text: task.prompt)]
            )
        ]
        if !contents.isEmpty {
            messages.append(Message(
                role: .user,
                content: contents
            ))
        }
        
        let requestStruct = CompletionRequest(
            messages: messages
        )
                
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let jsonData = try encoder.encode(requestStruct)
            request.httpBody = jsonData
            request.timeoutInterval = 60 // time out in 1 min

            return request
        } catch (let error) {
            print("error while encoding: \(error)")
            return nil
        }
    }
}

