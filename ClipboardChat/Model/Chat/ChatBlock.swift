//
//  ChatBlock.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/09.
//


enum ChatBlock {
    case instruction(String)
    case result(TaskResult)
    case error(String)
}
