//
//  ResultView.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/04.
//


import SwiftUI

struct ResultView: View {
    static let windowIdentifier = "Result"
    
    let id: TaskResult.ID
    @State private var result: TaskResult?
    @Environment(ChatManager.self) private var chatManager
    
    @State private var selectedItem: PasteboardItem?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let result {
                    Text("Result for \(result.task.name) Task")
                        .font(.title3)
                        .fontWeight(.bold)
                    ItemsView(items: result.items, selectedItem: $selectedItem)
                    MessageView(message: result.message)
                } else {
                    
                    HStack(spacing: 12) {
                        PikachuIcon()
                        Text("Result not found...")
                            .padding(.trailing, 4)
                    }
                    .fontWeight(.bold)
                    .roundedCornerBackground(horizontalPadding: 8, backgroundColor: .orange)
                    .padding(.top, 32)
                }
                
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .scrollTargetLayout()

        }
        .frame(width: 600)
        .frame(minHeight: 400, alignment: .top)
        .onAppear {
            self.result = chatManager.getTaskResult(id)
        }
        .sheet(item: $selectedItem, content: { _ in
            ItemPopup(selectedItem: $selectedItem)
                .frame(width: 400, height: 320)
        })

    }
}

private struct MessageView: View {
    var message: String
    
    var body: some View {

        VStack(spacing: 8) {
            Text("AI's Response")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.semibold)

            Text(message)
                .lineSpacing(4)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .foregroundStyle(.black.opacity(0.8))
                .background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.8)))
                .frame(maxWidth: .infinity, alignment: .leading)

        }
        .frame(maxWidth: .infinity, alignment: .leading)

            
    }
}

private struct ItemsView: View {
    var items: [PasteboardItem]
    @Binding var selectedItem: PasteboardItem?
    
    var body: some View {
    
        VStack(spacing: 8) {
            Text("Items Sent")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.semibold)
            
            if (items.count == 0) {
                Text("No Item was sent.")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            
            ForEach(0..<items.count, id: \.self) { index in
                let item = items[index]
                Button(action: {
                    selectedItem = item
                }, label: {
                    HStack(spacing: 0) {
                        switch item {
                        case .image(_, let image, _):
                            
                            Text("\(index + 1). Image: ")
                
                            Image(nsImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                            
                        case .string(_, let text, _):

                            Text("\(index + 1). Text: \(text)")
                                .lineLimit(1)
                                .frame(maxWidth: 240, alignment: .leading)


                        case .other(_, _, _):
                            Color.clear
                                .frame(width: 0, height: 0)
                        }
                    }
                    .foregroundStyle(.blue)
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .leading)
                })
                .buttonStyle(.plain)
               

            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}

#Preview {
    VStack {
        ItemsView(items: [
            
        ], selectedItem: .constant(.string(UUID(), "SomethingSomethingSomethingSomethingSomethingSomethingSomethingSomething", Date())))
//        ItemDetailView(selectedItem: .constant(.string(UUID(), "SomethingSomethingSomethingSomethingSomethingSomethingSomethingSomething", Date())))
//            .frame(width: 320, height: 320)
//
//        ItemDetailView(item: .image(UUID(), NSImage(named: "pikachu")!, Date()))
//            .frame(width: 320, height: 320)

        ResultView(id: UUID())
//            .frame(maxWidth: 600)

    }
    .frame(height: 400, alignment: .top)
    .environment(ChatManager.shared)


}
