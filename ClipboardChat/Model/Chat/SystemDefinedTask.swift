//
//  AITask.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//

import SwiftUI

enum SystemDefinedTask: Identifiable, CaseIterable {
    case analyze
    case codeEnhance
    case explain
    case summarize
    case translate
}


extension SystemDefinedTask {
    var prompt: String {
        switch self {
        case .summarize:
            return "Summarize the contents passed in by the user."
        case .explain:
            return "Explain the contents passed in by the user."
        case .analyze:
            return "Analyze the contents passed in by the user."
        case .codeEnhance:
            return "Improve the code passed in by the user. This include debugging and refactoring, if applicable."
        case .translate:
            return "Translate the contents passed in by the user to \(UserDefaultsManager.shared.translationTargetLanguage). If the content is an image, summarize it with the target language."
        }
    }
    
    var name: String {
        switch self {
        case .summarize:
            return "Summarize"
        case .explain:
            return "Explain"
        case .analyze:
            return "Analyze"
        case .codeEnhance:
            return "Code Enhance"
        case .translate:
            return "Translate"
        }
    }
    
    var id: String {
        return self.name
    }
    
}
