//
//  AITask.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/12.
//

import SwiftUI

enum AITask {
    case system(SystemDefinedTask)
    case custom(CustomTask)
    
    var isCustom: Bool {
        if case .custom = self {
            return true
        } else {
            return false
        }
    }
    
    var name: String {
        switch self {
        case .system(let systemTask):
            systemTask.name
        case .custom(let customTask):
            customTask.name
        }
    }
    
    var prompt: String {
        switch self {
        case .system(let systemTask):
            systemTask.prompt
        case .custom(let customTask):
            customTask.prompt
        }
    }
}

extension AITask: Identifiable {
    public var id: String {
        switch self {
        case .system(let systemTask):
            systemTask.name
        case .custom(let customTask):
            customTask.id.uuidString
        }
    }
}
