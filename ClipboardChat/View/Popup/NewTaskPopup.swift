//
//  NewTaskPopup.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/10.
//

import SwiftUI

private enum InputField: CaseIterable {
    case name
    case prompt
}

struct NewTaskPopup: View {
//    @FocusState private var focusedInput: InputField?
    @Binding var showPopup: Bool
    
    @Environment(UserDefaultsManager.self) private var userDefaultsManager
    @State private var name = ""
    @State private var prompt = ""

    var body: some View {
        PopupContainer(content: {
            VStack(spacing: 24) {
                HStack {
                    Text("New Custom Task")
                        .font(.title3)

                    Spacer()

                    Button(action: {
                        showPopup = false
                    }, label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    })
                    
                    Button(action: {
                        userDefaultsManager.customTasks.append(CustomTask(name: name, prompt: prompt))
                        showPopup = false
                    }, label: {
                        Text("Save")
                    })
                }
                
                HStack(spacing: 8) {
                    Text("Name")
                        .frame(width: 48, alignment: .leading)
                    CustomTextField(text: $name, placeholder: "Custom Task Name", disableAutoCorrection: false)
                }
                
                HStack(spacing: 8) {
                    Text("Prompt")
                        .frame(width: 48, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .top)

                    CustomTextEditor(text: $prompt, placeholder: "Custom Task Prompt", minHeight: 20, maxHeight: 96, fontSize: 12, horizontalPadding: 4, verticalPadding: 2, buttonTrailingPadding: 4)
                        .frame(maxHeight: .infinity, alignment: .top)

                }
                .fixedSize(horizontal: false, vertical: true)

            }
            .frame(maxHeight: .infinity, alignment: .top)

        }, onCloseButtonPress: {
            showPopup = false
        })
    }
}

#Preview {
    NewTaskPopup(showPopup: .constant(true))
        .frame(width: 400, height: 280)
        .environment(UserDefaultsManager.shared)

}
