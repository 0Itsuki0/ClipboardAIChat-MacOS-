//
//  PopupContainer.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/10.
//


import SwiftUI

struct PopupContainer<Content: View>: View {
    @ViewBuilder var content: Content
    var onCloseButtonPress: (() -> Void)
    
    var body: some View {
        content
            .padding(.all, 48)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay(alignment: .topTrailing, content: {
                Button(action: {
                    onCloseButtonPress()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .fontWeight(.semibold)
//                        .font(.system(size: 8))
                })
                .keyboardShortcut(.return, modifiers: .command)
                .foregroundStyle(.red)
                .buttonStyle(.plain)
                .padding(.all, 4)
//                .background(Circle().fill(.red))
                .padding(.all, 12)
            })
//            .background(.blue)
    }
}
