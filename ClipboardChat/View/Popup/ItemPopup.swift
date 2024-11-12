//
//  ItemPopup.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/07.
//

import SwiftUI

struct ItemPopup: View {
    @Binding var selectedItem: PasteboardItem?
    
    var body: some View {
        if let item = selectedItem {
            PopupContainer(content: {
                ScrollView {
                    switch item {
                    case .image(_, let image, _):
                        
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()
                        
                    case .string(_, let text, _):

                        Text("\(text)")
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)


                    case .other(_, let type, _):
                        Text("Unsupported class \(type.self)")
                    }
                }
                .scrollIndicators(.hidden)
            }, onCloseButtonPress: {
                selectedItem = nil
            })
        }
    }
}
