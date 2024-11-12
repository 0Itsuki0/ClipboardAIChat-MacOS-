//
//  CustomTask.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//

import SwiftUI

struct CustomTaskSettings: View {
    @Environment(UserDefaultsManager.self)  private var userDefaultsManager
//    @State private var selection: CustomTask.ID?
    @State private var selections: Set<CustomTask.ID> = Set()
    @State private var showAddTask: Bool = false
    @State private var taskDetail: CustomTask?

    var body: some View {
//        @Bindable var manager = userDefaultsManager
        VStack(spacing: 16) {
            HStack {
                Text("Custom Tasks")
                    .font(.title3)
                
                Spacer()

                Button(action: {
                    showAddTask = true
                }, label: {
                    Text("+")
                        .frame(width: 8)
                })
                .disabled(userDefaultsManager.customTasks.count >= 5)
                
                Button(action: {
                    userDefaultsManager.customTasks.removeAll(where: { task in
                        selections.contains(where: { selected in
                        return selected == task.id
                    })})
                }, label: {
                    Text("-")
                        .frame(width: 8)
                })
            }
            .padding(.horizontal, 4)

            Table(of: CustomTask.self, selection: $selections,  columns: {
                TableColumn("Name", content: { customTask in
                    Text("\(customTask.name)")
                })
                .width(min: 48, ideal: 48)
                
                TableColumn("Prompt", content: { customTask in
                    HStack(spacing: 16) {
                        Text("\(customTask.prompt)")
                            .lineLimit(1)
                        
                        Button(action: {
                            taskDetail = customTask
                        }, label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                        })
                        .foregroundStyle(.blue)
                    }
                })

            }, rows: {
                ForEach(userDefaultsManager.customTasks) { customTask in
                    TableRow(customTask)
                        .draggable(customTask)
                }
                .dropDestination(for: CustomTask.self, action: { index, tasks in
                    guard let firstCustomTask = tasks.first, let firstRemoveIndex = userDefaultsManager.customTasks.firstIndex(where: {$0.id == firstCustomTask.id}) else { return }
                    
                    userDefaultsManager.customTasks.removeAll(where: { customTask in
                        tasks.contains(where: { insertCustomTask in insertCustomTask.id == customTask.id})
                    })
                    
                    userDefaultsManager.customTasks.insert(contentsOf: tasks, at: (index > firstRemoveIndex ? (index - 1) : index))
                })

            })
            .frame(height: 172)
            .scrollDisabled(true)
            
            VStack(spacing: 4) {
                Text("* Predefine custom tasks for fast access. Maximum of 5.")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)

                
                Text("* Custom tasks will show up in the order defined here. Drag and drop to change the order")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $showAddTask, content: {
            NewTaskPopup(showPopup: $showAddTask)
                .frame(width: 400, height: 280)
        })
        .sheet(item: $taskDetail, content: { _ in
            PromptDetailPopup(selectedTask: $taskDetail)
                .frame(width: 320, height: 280)
        })
    }
}



#Preview {
    CustomTaskSettings()
        .padding(.all, 32)
        .frame(width: 600, height: 400)
        .environment(UserDefaultsManager.shared)

}
