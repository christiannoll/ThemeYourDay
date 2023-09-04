//
//  DataFactory.swift
//  ThemeYourDay
//
//  Created by Christian on 01.05.23.
//

import Foundation

struct DataFactory {
    static var days: [Day] = []
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
    
    static func currentDay() -> Day {
        let today = Date().noon
        for day in days {
            if day.id.hasSame(.day, as: today) {
                return day
            }
        }
        let newDay = Day(id: today, text: "Could not find Today!", fgColor: DayColor())
        return newDay
    }
    
    static func currentIndex() -> Int {
        let today = Date().noon
        var index = -1
        for day in days {
            index += 1
            if day.id.hasSame(.day, as: today) {
                break
            }
        }
        return index
    }
}
