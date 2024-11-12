//
//  CustomTextEditor.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/10.
//

import SwiftUI

struct CustomTextEditor: View {
    @Binding var text: String
    var placeholder: String
    var minHeight: CGFloat
    var maxHeight: CGFloat
    var fontSize: CGFloat
    var horizontalPadding: CGFloat = 8
    var verticalPadding: CGFloat = 8
    var buttonTrailingPadding: CGFloat = 0

    var body: some View {
        TextEditor(text: $text)
            .textEditorStyle(.plain)
            .foregroundStyle(.black)
            .lineSpacing(2)
            .padding(.trailing, 8)
            .overlay(alignment: .leading, content: {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.gray)
                        .allowsHitTesting(false)
                        .padding(.leading, 4)
                }
            })
            .overlay(alignment: .topTrailing, content: {
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    })
                    .buttonStyle(.plain)
                    .padding(.trailing, buttonTrailingPadding)
                }
            })
            .font(.system(size: fontSize))
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(RoundedRectangle(cornerRadius: 4).fill(.white.opacity(0.8)))
            .frame(minHeight: minHeight, maxHeight: maxHeight)
            .fixedSize(horizontal: false, vertical: true)
    }
}
