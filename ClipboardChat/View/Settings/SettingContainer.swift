//
//  SettingContainer.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//

import SwiftUI

struct SettingContainer: View {
//    @AppStorage("selectedSettingsTab")
//    private var selectedSettingsTab = SettingsTab.general

    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                GeneralSettings()
            }
            Tab("Custom Tasks", systemImage: "star") {
                CustomTaskSettings()
            }

        }
        .padding(.all, 32)
        .frame(width: 600, height: 400)
//        .tabViewStyle(.)
    }
}

enum SettingsTab: Int {
    case general
    case customTasks
}
