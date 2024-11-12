//
//  APIKey.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//

import SwiftUI


// API Key, custom pooling interval
struct GeneralSettings: View {
    @Environment(UserDefaultsManager.self) var userDefaultsManager
    @State private var apiKeyEntry: String = ""
    @State private var languageEntry: String = ""
    @State private var pollingInterval: Double = 0

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Text("API Key:")
                    
                    CustomTextField(text: $apiKeyEntry, placeholder: "OpenAI API Key...", disableAutoCorrection: true)
                    Button(action: {
                        userDefaultsManager.apiKey = apiKeyEntry
                    }, label: {
                        Text("Save")
                    })
                }
                
                Text("OpenAI API Key. You can create one in the  [dashboard](https://platform.openai.com/api-keys).")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Text("Translate Task Target Language:")

                    CustomTextField(text: $languageEntry, placeholder: "Target Language...", disableAutoCorrection: false)
                    
                    Button(action: {
                        userDefaultsManager.translationTargetLanguage = languageEntry
                    }, label: {
                        Text("Save")
                    })
                }
                
                Text("Target language for translation task.")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)


            }
            .frame(maxWidth: .infinity, alignment: .leading)

            
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Text("Pasteboard Polling Interval (sec):")
                    Text("every \(String(format: "%.1f", pollingInterval)) sec")
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Slider(
                    value: $pollingInterval,
                    in: PasteboardManager.minPollingInterval...PasteboardManager.maxPollingInterval,
                    step: 0.1,
                    label: {},
                    minimumValueLabel: {
                        Text(String(format: "%.1f", PasteboardManager.minPollingInterval))
                    },
                    maximumValueLabel: {
                        Text(String(format: "%.1f", PasteboardManager.maxPollingInterval))
                    },
                    onEditingChanged: { isEditing  in
                        if !isEditing {
                            userDefaultsManager.pollingInterval = pollingInterval
                        }
                    }
                )
                
                Text("Time Interval in seconds between polling for pasteboards changes.")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)

                
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .onAppear {
            self.apiKeyEntry = userDefaultsManager.apiKey
            self.languageEntry = userDefaultsManager.translationTargetLanguage
            self.pollingInterval = userDefaultsManager.pollingInterval
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}


#Preview {
    GeneralSettings()
        .padding(.all, 32)
        .frame(width: 600, height: 400)
        .environment(UserDefaultsManager.shared)

}
