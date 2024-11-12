//
//  ClipboardChatApp.swift
//  ClipboardChat
//
//  Created by Itsuki on 2024/11/12.
//

import SwiftUI

@main
struct ClipboardChatApp: App {
    
    let panelManager = PanelManager.shared
    let pasteboardManager = PasteboardManager.shared
    let chatManager = ChatManager.shared
    let userDefaultsManager = UserDefaultsManager.shared
    
    var body: some Scene {
        
        MenuBarExtra(content: {
            AppMenu()
                .environment(panelManager)
                .environment(pasteboardManager)
                .environment(chatManager)
                .environment(userDefaultsManager)

            
        }, label: {
            HStack {
                Image(systemName: "heart.fill")
                Text("Itsuki AI")
            }
        })
        .menuBarExtraStyle(.window)
        
        Settings {
            SettingContainer()
                .environment(panelManager)
                .environment(pasteboardManager)
                .environment(chatManager)
                .environment(userDefaultsManager)
                .fixedSize(horizontal: true, vertical: true)
        }
        .defaultSize(width: 600, height: 400)
        .defaultPosition(.center)
        .windowResizability(.contentSize)

        
        
        Window("Pasteboard Items", id: PasteboardItemsView.windowIdentifier, content: {
            PasteboardItemsView()
                .environment(panelManager)
                .environment(pasteboardManager)
                .environment(chatManager)
                .environment(userDefaultsManager)
                .fixedSize(horizontal: true, vertical: false)

        })
        .defaultSize(width: 600, height: 400)
        .windowResizability(.contentSize)
        .defaultPosition(.bottomTrailing)

        
        Window("Chat", id: ChatView.windowIdentifier, content: {
            ChatView()
                .environment(panelManager)
                .environment(pasteboardManager)
                .environment(chatManager)
                .environment(userDefaultsManager)
                .fixedSize(horizontal: true, vertical: false)

        })
        .defaultSize(width: 600, height: 400)
        .windowResizability(.contentSize)
        .defaultPosition(.center)
        
        
        WindowGroup("Result", id: ResultView.windowIdentifier, for: TaskResult.ID.self, content: { $resultId in
            if let resultId {
                ResultView(id: resultId)
                    .environment(panelManager)
                    .environment(pasteboardManager)
                    .environment(chatManager)
                    .environment(userDefaultsManager)
                    .fixedSize(horizontal: true, vertical: false)

            }
        })
        .defaultSize(width: 600, height: 400)
        .defaultPosition(.center)
        .windowResizability(.contentSize)


    }
}
