//
//  CustomTextField.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/10.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var disableAutoCorrection: Bool
    
    var body: some View {
        TextField("", text: $text)
            .autocorrectionDisabled(disableAutoCorrection)
            .textFieldStyle(.plain)
            .foregroundStyle(.black.opacity(0.8))
            .frame(maxWidth: .infinity)
            .lineLimit(1)
            .lineSpacing(2)
            .padding(.trailing, 8)
            .overlay(alignment: .leading, content: {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.gray)
                        .allowsHitTesting(false)
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
                }
            })
            .font(.system(size: 12))
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .background(RoundedRectangle(cornerRadius: 4).fill(.white.opacity(0.8)))
    }
}
//
//struct CustomTextFieldStyle: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration.
//    }
//}
