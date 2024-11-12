//
//  RoundedCornerBackground.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/10.
//

import SwiftUI

extension View {
    func roundedCornerBackground(alignment: Alignment = .center, horizontalPadding: CGFloat = 16, backgroundColor: Color = .white.opacity(0.8)) -> some View {
        modifier(RoundedCornerBackground(alignment: alignment, horizontalPadding: horizontalPadding, backgroundColor: backgroundColor))
    }
}

private struct RoundedCornerBackground: ViewModifier {
    var alignment: Alignment
    var horizontalPadding: CGFloat
    var backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 8)
//            .padding(.all, 8)
            .frame(minWidth: 200, alignment: alignment)
            .background(RoundedRectangle(cornerRadius: 8).fill(backgroundColor))
//            .padding(.horizontal, 64)
    }
}
