//
//  AppMenu.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/02.
//

import SwiftUI
import Combine

struct AppMenu: View {
    @Environment(PanelManager.self) var panelManager
    @Environment(PasteboardManager.self) var pasteboardManager
    
    @State private var enabled: Bool = true
    @Environment(\.openSettings) private var openSettings
    private let buttonStyle = LinkButtonStyle()

    var body: some View {
        VStack(spacing: 4) {
            Toggle(isOn: $enabled, label: {
                Text("Enabled")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
            })
            .toggleStyle(.switch)
            .padding(.top, 8)
            .padding(.bottom, 4)

            
            Divider()
                .foregroundStyle(.black)
                .padding(.vertical, 4)

            Button(action: {
                openSettings()
    //            panelManager.showPanel()
            }, label: {
                Text("Settings")
                    .frame(maxWidth: .infinity, alignment: .leading)

            })
            .buttonStyle(buttonStyle)
            
            Button(action: {
                NSApplication.shared.terminate(nil)
    //            panelManager.showPanel()
            }, label: {
                Text("Terminate")
                    .frame(maxWidth: .infinity, alignment: .leading)

            })
            .buttonStyle(buttonStyle)

            
        }
        .padding(.all, 4)
        .frame(width: 160)
        .onChange(of: enabled, {
            print("isAppOn: \(enabled)")
            if enabled {
                enablePasteboard()
            } else {
                disablePasteboard()
            }
        })

    }
    
    private func disablePasteboard() {
        panelManager.disableMonitor()
        pasteboardManager.stopPooling()
    }
    
    private func enablePasteboard() {
        panelManager.enableMonitor()
        pasteboardManager.startPooling()
    }
    

}

#Preview {

    AppMenu()
        .environment(PanelManager.shared)
        .environment(PasteboardManager.shared)
}
