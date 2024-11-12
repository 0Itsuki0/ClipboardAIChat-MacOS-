//
//  NSImage+Extensions.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/04.
//

import AppKit

extension NSImage {
    var data: Data? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let rep = NSBitmapImageRep(cgImage: cgImage)
        rep.size = self.size
        return rep.representation(using: .png, properties: [:])
    }
}
