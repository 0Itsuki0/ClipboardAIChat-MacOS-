//
//  ClipboardManager.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/02.
//

import SwiftUI


@Observable
class PasteboardManager {
    static let shared = PasteboardManager()
    static let defaultPollingInterval = 0.5
    static let minPollingInterval = 0.1
    static let maxPollingInterval = 2.0

    
    var showItemAdded: Bool = false
    
    @MainActor var items: [PasteboardItem] = []

    private var changeCount: Int = 0
    private let pasteboard: NSPasteboard = .general
    private var timer: Timer?
    private let pollingInterval = 0.5

    init() {
        self.changeCount = self.pasteboard.changeCount
        self.timer = Timer.scheduledTimer(timeInterval: pollingInterval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc private func timerFired() {
        let newCount = self.pasteboard.changeCount
        if newCount != changeCount {
            print("new change: \(newCount)")
            self.changeCount = newCount
            Task.detached { @MainActor in
                self.showItemAdded = true
                PanelManager.shared.showPanel()
                Task.detached {
                    await self.appendNewChanges()
                }
            }
        }
    }
    
    func stopPooling() {
        timer?.invalidate()
    }
    
    func startPooling() {
        self.changeCount = self.pasteboard.changeCount
        timer = Timer.scheduledTimer(timeInterval: pollingInterval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @MainActor
    func removeItem(_ item: PasteboardItem) {
        self.items.removeAll(where: {$0.id == item.id})
    }
    
    @MainActor
    func removeItems(_ ids: Set<PasteboardItem.ID>) {
        self.items.removeAll(where: {ids.contains($0.id)})
    }
    
    @MainActor
    func removeAll() {
        self.items = []
    }
    
    @MainActor
    func appendNewChanges() {
        let now = Date()

        guard let objects = pasteboard.readObjects(forClasses: [NSString.self, NSImage.self, NSAttributedString.self, NSURL.self, NSColor.self, NSSound.self, NSPasteboardItem.self]) else {
            print("fail to read items")
            return
        }
        var items: [PasteboardItem] = []

        for object in objects {
            let id = UUID()
            switch object {
            case is NSString:
                items.append(.string(id, object as! NSString as String, now))
           
            case is NSImage:
                items.append(.image(id, object as! NSImage, now))
            
            case is NSAttributedString:
                let attributedString = object as! NSAttributedString
                items.append(.string(id, attributedString.string, now))
            
            case is NSURL:
                let url = object as! NSURL
                items.append(.string(id, url.absoluteString ?? "Unknown URL", now))

            case is NSColor:
                items.append(.other(id, NSColor.self, now))
                
            case is NSSound:
                items.append(.other(id, NSSound.self, now))

            default:
                items.append(.other(id, NSPasteboardItem.self, now))
            }
        }

        self.items.append(contentsOf: items)
    }

}
