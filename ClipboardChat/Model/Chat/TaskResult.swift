//
//  TaskResult.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//

import SwiftUI

struct TaskResult: Identifiable {
    var id: UUID = UUID()
    var task: AITask
    var items: [PasteboardItem]
    var message: String
}
