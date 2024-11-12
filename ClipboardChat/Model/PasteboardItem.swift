//
//  PasteboardItem.swift
//  MacClipboardAIChat
//
//  Created by Itsuki on 2024/11/04.
//

import SwiftUI

enum PasteboardItem {
    case string(UUID, String, Date)
    case image(UUID, NSImage, Date)
    case other(UUID, AnyClass, Date)
}

extension PasteboardItem {
    static func getItemsOverview(_ items: [PasteboardItem]) -> (string: Int, image: Int, other: Int) {
        var string = 0
        var image = 0
        var other = 0
        for item in items {
            switch item {
            case .string(_, _, _):
                string += 1
            case .image(_, _, _):
                image += 1
            default:
                other += 1
            }
        }
        return (string, image, other)
    }
    
    static func toContents(_ items: [PasteboardItem]) -> [MessageContent] {
        var contents: [MessageContent] = []
//        var strings: [String] = []
//        var images: [String] = []

        for item in items {
            switch item {
            case .string(_, let text, _):
                contents.append(.init(text: text))
//                strings.append(string)
            case .image(_, let image, _):
                guard let data = image.data else { break }
                let base64 = data.base64EncodedString()
                contents.append(.init(imageUrl: "data:image/png;base64,\(base64)"))
//                images.append(data.base64EncodedString())
            default:
                break
            }
        }
        return contents
    }
    
    static func base64Images(in items: [PasteboardItem]) -> [String] {
        var images: [String] = []
        for item in items {
            switch item {
            case .image(_, let image, _):
                guard let data = image.data else { break }
                images.append(data.base64EncodedString())
            default:
                break
            }
        }
        return images
    }
}

extension PasteboardItem {
    var iconName: String {
        switch self {
        case .string(_, _, _):
            "text.quote"
        case .image(_, _, _):
            "photo"
        case .other(_, _, _):
            "camera.metering.unknown"
        }
    }
    
    var date: Date {
        switch self {
        case .string(_, _, let date):
            return date
        case .image(_, _, let date):
            return date
        case .other(_, _, let date):
            return date
        }
    }
    

}

extension PasteboardItem: Identifiable {
    var id: UUID {
        switch self {
        case .string(let id, _, _):
            return id
        case .image(let id, _, _):
            return id
        case .other(let id, _, _):
            return id
        }
    }
}

extension PasteboardItem: Hashable, Equatable {
    static func == (lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
