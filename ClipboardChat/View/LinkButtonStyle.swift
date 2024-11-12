//
//  LinkButtonStyle.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//

import SwiftUI

struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(configuration.isPressed ? Color.blue : Color.clear)
            .foregroundStyle(.white)
            .contentShape(RoundedRectangle(cornerRadius: 4))
    }

}
