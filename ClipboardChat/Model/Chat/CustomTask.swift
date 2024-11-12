//
//  CustomTask.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//

import SwiftUI
import UniformTypeIdentifiers

struct CustomTask: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var prompt: String
}

extension CustomTask: Transferable {
    static var draggableType = UTType(exportedAs: "itsuki.enjoy.customTask")
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: CustomTask.draggableType)
    }
}
