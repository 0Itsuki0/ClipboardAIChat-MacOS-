//
//  FloatingView.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/02.
//

import SwiftUI

struct PanelView: View {
    
    @State private var showMenu = true
    @Environment(\.openWindow) private var openWindow
    
    private let buttonStyle = LinkButtonStyle()
    
    var body: some View {
        
        VStack(spacing: 0) {
            Button(action: {
                showMenu.toggle()
            }, label: {
                Image("pikachu")
                    .resizable()
                    .scaledToFit()
                    .frame(width: PanelManager.iconWidth)
                    .contentShape(Rectangle())
            })
            .buttonStyle(.plain)

            Spacer()
                .frame(height: 16)
            
            if showMenu {
                VStack(spacing: 0) {
                    ForEach(SystemDefinedTask.allCases) { systemTask in
                        Button(action: {
                            openWindow(id: ChatView.windowIdentifier)
                            Task.detached {
                                await ChatManager.shared.sendCompletionRequest(task: .system(systemTask), items: PasteboardManager.shared.items)
                            }
                            
                        }, label: {
                            Text(systemTask.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        })
                    }
                    
                    
                    Divider()
                        .foregroundStyle(.black)
                        .padding(.vertical, 4)
                    
                    if !UserDefaultsManager.shared.customTasks.isEmpty {
                        
                        let customTasks = UserDefaultsManager.shared.customTasks
                        ForEach(customTasks) { customTask in
                            Button(action: {
                                openWindow(id: ChatView.windowIdentifier)
                                Task.detached {
                                    await ChatManager.shared.sendCompletionRequest(task: .custom(customTask), items: PasteboardManager.shared.items)
                                }
                            }, label: {
                                Text(customTask.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                            })
                            .disabled(ChatManager.shared.isProcessing)

                        }
                
                        Divider()
                            .foregroundStyle(.black)
                            .padding(.vertical, 4)
                    }
                    
                    Button(action: {
                        openWindow(id: ChatView.windowIdentifier)
                    }, label: {
                        Text("Open Chat")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })

                                        
                    Button(action: {
                        openWindow(id: PasteboardItemsView.windowIdentifier)
                    }, label: {
                        Text("Manage Clipboard")
                            .frame(maxWidth: .infinity, alignment: .leading)

                    })
                    .background(.orange)                    

                }
                .padding(.all, 4)
                .frame(width: 180)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color(nsColor: .gray)))
                
            }
        }
        .buttonStyle(buttonStyle)
        .overlay(alignment: .topTrailing, content: {
            if PasteboardManager.shared.showItemAdded {
                Text("Added!")
                    .padding(.all, 12)
                    .foregroundStyle(.black)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.white))
                    .padding(.top, 16)
            }
        })
        .onHover(perform: { isHovering in
            print(isHovering)
            PanelManager.shared.isHovering = isHovering
        })
        .frame(width: PanelManager.panelSize.width, height: PanelManager.panelSize.height, alignment: .top)
        
    }
}



#Preview {
    PanelView()
}
