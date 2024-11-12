//
//  ClipboardItemView.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/04.
//

import SwiftUI

struct PasteboardItemsView: View {
    static let windowIdentifier = "ClipboardItems"
    
    @Environment(PasteboardManager.self) private var pasteboardManager
    @State private var selections = Set<PasteboardItem.ID>()

    @State private var selectedItem: PasteboardItem?


    var body: some View {
        @Bindable var pasteboardManager = pasteboardManager

        List(selection: $selections, content: {
            ForEach($pasteboardManager.items, editActions: [.move], content: { $item in
                ItemView(item: item, selectedItem: $selectedItem)
                    .alignmentGuide(.listRowSeparatorLeading) { d in
                        d[.leading]
                    }
                    .alignmentGuide(.listRowSeparatorTrailing) { d in
                        d[.trailing]
                    }
            })

        })
        .toolbar(content: {
            Button(action: {
                pasteboardManager.removeAll()
            }, label: {
                Text("Remove All")
                    .foregroundStyle(.red)
                    .padding(.horizontal, 8)

            })
        })
        .contextMenu(forSelectionType: PasteboardItem.ID.self, menu: { ids in
            Button(action: {
                print(ids)
                pasteboardManager.removeItems(ids)
            }){
                Text("Delete")
                    .foregroundStyle(.red)
                    .padding(.horizontal, 8)
            }
        })
        .frame(width: 600)
        .frame(minHeight: 400, alignment: .top)
        .sheet(item: $selectedItem, content: { _ in
            ItemPopup(selectedItem: $selectedItem)
                .frame(width: 400, height: 320)
        })
    }
}

private struct ItemView: View {
    
    let item: PasteboardItem
    @Binding var selectedItem: PasteboardItem?
    
    @Environment(PasteboardManager.self) private var pasteboardManager

    
    var body: some View {
        let detailButton = Button(action: {
            selectedItem = item
        }, label: {
            Image(systemName: "magnifyingglass.circle.fill")
        })
        .buttonStyle(.plain)
        .foregroundStyle(.blue)

        HStack(spacing: 24) {
            
            icon(item.iconName)
            
            HStack(spacing: 16) {
                switch item {
                case .string(_, let string, _):
                    Text(string)
                        .lineLimit(2)
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                    
                    detailButton
                    
                case .image(_, let image, _):
                    
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                    
                    detailButton
                    
                    
                case .other(_, let other, _):
                    Text("Unsupported Type: \n\(other)")
                        .lineLimit(2)
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)

                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            
            Spacer()

            HStack(spacing: 8) {
                Text(item.date.formatted(date: .numeric, time: .shortened))
                    .font(.caption)
                    .frame(maxHeight: .infinity, alignment: .center)
                
                Button(action: {
                    pasteboardManager.removeItem(item)
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                })
                .buttonStyle(.plain)

            }

        }
        .padding(.horizontal, 8)
        .frame(height: 64)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func icon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
            .padding(.all, 12)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .gray)))
            .frame(width: 48, height: 48)

    }
}


#Preview {
    let pasteboardManager = PasteboardManager.shared
    pasteboardManager.items = [
        .image(UUID(),NSImage(named: "pikachu")!, Date()),
        .string(UUID(), "testtesttesttesttesttesttesttesttesttesttest\ntest", Date()),
        .other(UUID(), NSColor.self, Date())
    ]
    
    return PasteboardItemsView()
        .environment(pasteboardManager)
        .frame(width: 480)

}
