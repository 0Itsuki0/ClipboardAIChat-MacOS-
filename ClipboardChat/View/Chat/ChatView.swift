//
//  ChatView.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/04.
//


import SwiftUI

struct ChatView: View {
    static let windowIdentifier = "Chat"
    
    @Environment(\.openWindow) private var openWindow
    @Environment(ChatManager.self) private var chatManager
    @Environment(UserDefaultsManager.self) private var userDefaultsManager
    @Environment(PasteboardManager.self) private var pasteboardManager

    @State private var showCustomTaskMenu: Bool = false

    @State var prompt = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(0..<chatManager.chats.count, id: \.self) { index in
                            let chat = chatManager.chats[index]
                            switch chat {
                            case .error(let error):
                                ErrorView(error: error)
                            case .result(let result):
                                FinishView(result: result)
                            case .instruction(let instruction):
                                InstructionView(instruction: instruction)
                            }
                        }
                        
                        if chatManager.isProcessing {
                            LoadingView()
                                .id(chatManager.chats.count)
                        }
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    .scrollTargetLayout()
                    
                }

                VStack(spacing: 8) {
                    HStack {
                        ForEach(SystemDefinedTask.allCases) { systemTask in
                            Button(action: {
                                Task.detached {
                                    await chatManager.sendCompletionRequest(task: .system(systemTask), items: pasteboardManager.items)
                                }
                            }, label: {
                                    Text(systemTask.name)
                                    .foregroundStyle(.black.opacity(0.8))
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .frame(maxHeight: .infinity, alignment: .center)
                                    .background(RoundedRectangle(cornerRadius: 4))

                            })
                            .disabled(chatManager.isProcessing)
                        }
                        
                        
                        if !userDefaultsManager.customTasks.isEmpty {
                            
                            Button(action: {
                                showCustomTaskMenu.toggle()
                            }, label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.black.opacity(0.8))
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .frame(maxHeight: .infinity, alignment: .center)
                                    .background(RoundedRectangle(cornerRadius: 4))

                            })
                            .disabled(chatManager.isProcessing)
                            .overlay(content: {
                                if showCustomTaskMenu {
                                    let customTasks = userDefaultsManager.customTasks
                                    GeometryReader { proxy in
                                        VStack(spacing: 0) {
                                            ForEach(customTasks) { customTask in
                                                Button(action: {
                                                    Task.detached {
                                                        await chatManager.sendCompletionRequest(task: .custom(customTask), items: pasteboardManager.items)
                                                    }
                                                }, label: {
                                                    Text(customTask.name)
                                                        .frame(maxWidth: 150, alignment: .center)
                                                        .lineLimit(1)
                                                })
                                                .buttonStyle(LinkButtonStyle())
                                                .disabled(chatManager.isProcessing)

                                            }
                                        }
                                        .fixedSize(horizontal: true, vertical: false)
                                        .padding(.all, 4)
                                        .background(RoundedRectangle(cornerRadius: 4).fill(Color(nsColor: .lightGray)))
                                        .position(x: proxy.size.width/2, y: -(Double(customTasks.count)/2)*proxy.size.height-12)

                                    }
                                }
                            })
                        }
                        

                        Button(action: {
                            openWindow(id: PasteboardItemsView.windowIdentifier)
                        }, label: {
                            Text("Clipboard")
                                .foregroundStyle(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .frame(maxHeight: .infinity, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 4).fill(.blue))
                        })


                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    
                    HStack {
                        CustomTextEditor(text: $prompt, placeholder: "Custom Task Prompt...", minHeight: 32, maxHeight: 120, fontSize: 12)

                        Button(action: {
                            print("sending custom prompt")
                            let customPrompt = prompt
                            prompt = ""
                            Task.detached {
                                await chatManager.sendCompletionRequest(task: .custom(CustomTask(name: "", prompt: customPrompt)), items: pasteboardManager.items)
                            }
                        }, label: {
                            Image(systemName: "paperplane.fill")
                        })
                        .keyboardShortcut(.return, modifiers: .command)
                        .disabled(prompt.isEmpty || chatManager.isProcessing)
                    }
                    .padding(.all, 8)
                    .background(.gray)
                }
                .onChange(of: prompt, {
                    scrollToBottom(proxy, animated: false)
                })
                .onChange(of: chatManager.chats.count, {
                    scrollToBottom(proxy, animated: true)
                })
                .onChange(of: chatManager.isProcessing, {
                    scrollToBottom(proxy, animated: true)
                })
                .onAppear {
                    scrollToBottom(proxy, animated: false)
                }
                

            }
        }
        .buttonStyle(.plain)
        .padding(.top, 16)
        .frame(width: 600)
        .frame(minHeight: 360, alignment: .top)
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy, animated: Bool) {
        let scrollToId = chatManager.isProcessing ? chatManager.chats.count : chatManager.chats.count - 1
        if animated {
            withAnimation {
                proxy.scrollTo(scrollToId, anchor: .bottom)
            }
        } else {
            proxy.scrollTo(scrollToId, anchor: .bottom)
        }
    }
}

private struct InstructionView: View {
    var instruction: String
    var body: some View {
        let localizedKey = LocalizedStringKey(instruction)
        Text(localizedKey)
            .foregroundStyle(.black.opacity(0.8))
            .lineSpacing(4)
            .multilineTextAlignment(.leading)
            .roundedCornerBackground()
            .padding(.horizontal, 64)
    }
}

private struct ErrorView: View {
    var error: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 16)
            
            Text(error)
                .padding(.horizontal, 8)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)

        }
        .fontWeight(.semibold)
        .foregroundStyle(.red.opacity(0.8))
        .roundedCornerBackground()
        .padding(.horizontal, 64)


    }
}


private struct FinishView: View {
    @Environment(\.openWindow) private var openWindow

    var result: TaskResult
    
    var body: some View {
        HStack(spacing: 16) {
            PikachuIcon()
                .padding(.vertical, 8)
                
            Text("\(result.task.name) Finished!")
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
            
            Button(action: {
                openWindow(id: ResultView.windowIdentifier, value: result.id)
            }, label: {
                Text("Result")
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, 8)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.blue))
            })
            .buttonStyle(.plain)

        }
        .fontWeight(.bold)
        .padding(.leading, 8)
        .frame(minWidth: 200, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 8).fill(.orange))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


private struct LoadingView: View {
    @State private var dots = 0
    var body: some View {
        HStack(spacing: 12) {
            HStack {
                PikachuIcon()
                ForEach(0..<dots, id: \.self) { _ in
                    Image(systemName: "ellipsis")
                }
            }
        }
        .fontWeight(.bold)
        .roundedCornerBackground(alignment: .leading, horizontalPadding: 8, backgroundColor: .orange)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            withAnimation(.linear(duration: 1.3).repeatForever(autoreverses: false)) {
                dots = 5
            }
        }
        
    }
}


#Preview {
    VStack {
        ChatView()
//        LoadingView()
//        ErrorView(error: "s")
//        InstructionView(instruction: "ddd")
    }
    .frame(maxWidth: 600)
    .environment(ChatManager.shared)
    .environment(UserDefaultsManager.shared)
    .environment(PasteboardManager.shared)
}

