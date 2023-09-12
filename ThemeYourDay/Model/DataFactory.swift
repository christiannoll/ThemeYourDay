//
//  DataFactory.swift
//  ThemeYourDay
//
//  Created by Christian on 01.05.23.
//

import Foundation

struct DataFactory {
    static let stickers: [Sticker] = loadStickers()
    static let snippets: [Snippet] = loadSnippets()
    static var indexCache : [Date:Int] = [:]
    
    static func loadStickers() -> [Sticker] {
        let stickers: [Sticker] = load("StickerData", type: .bundle, createData: createStickers)
        return stickers
    }
    
    static func loadSnippets() -> [Snippet] {
        let snippets: [Snippet] = load("SnippetData", type: .bundle, createData: createSnipppets)
        return snippets
    }
}
