//
//  PanelView.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/02.
//

import SwiftUI

class FloatingPanel: NSPanel {

    init(
        @ViewBuilder view: () -> some View,
        contentRect: NSRect) {
    
            super.init(
                contentRect: contentRect,
                styleMask: [.utilityWindow],
                backing: .buffered,
                defer: false)
                
            isFloatingPanel = true
            level = .floating
                
            collectionBehavior = [.canJoinAllSpaces]
            animationBehavior = .utilityWindow
            isMovableByWindowBackground = true

            hidesOnDeactivate = false
            contentView = NSHostingView(rootView: view())
            backgroundColor = .clear

    }

    override var canBecomeKey: Bool {
        return true
    }
     
    override var canBecomeMain: Bool {
        return true
    }
    
}
