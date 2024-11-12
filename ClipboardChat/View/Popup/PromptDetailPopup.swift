//
//  PromptDetailPopup.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/10.
//


import SwiftUI

struct PromptDetailPopup: View {
    @Binding var selectedTask: CustomTask?
    
    var body: some View {
        if let selectedTask {
            PopupContainer(content: {
                ScrollView {
                    Text("\(selectedTask.prompt)")
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .scrollIndicators(.hidden)
            }, onCloseButtonPress: {
                self.selectedTask = nil
            })
        }
    }
}
