//
//  DataFactory.swift
//  ThemeYourDay
//
//  Created by Christian on 01.05.23.
//

import Foundation

struct DataFactory {
    static var settings: Settings = loadSettings()
    static var days: [Day] = loadDays()
    static let stickers: [Sticker] = loadStickers()
    static let snippets: [Snippet] = loadSnippets()
    static var indexCache : [Date:Int] = [:]
    
    static func loadDays() -> [Day] {
        var loadedDays: [Day] = load("DayData.json", type: .container, createData: createData)
    
        let endDate = Date().getNextMonth()?.getNextMonth()?.noon
        guard var day = Date().getPreviousMonth()?.noon else {
            return loadedDays
        }
        
        while day != endDate {
            var loaded = false
            for loadedDay in loadedDays {
                if loadedDay.id.hasSame(.day, as: day) {
                    loaded = true
                    break
                }
            }
            
            if !loaded {
                let newDay = Day(id: day, text: settings.weekdaysText[day.weekday - 1],
                                 fgColor: settings.weekdaysFgColor[day.weekday - 1],
                                 bgColor: settings.weekdaysBgColor[day.weekday - 1])
                loadedDays.insert(newDay, at: 0)
            }
            
            day = day.dayAfter.noon
        }
        
        loadedDays.sort { $0.id < $1.id }
        
        for (index, day) in loadedDays.enumerated() {
            indexCache[day.id.noon] = index
        }
        
        return loadedDays
    }
    
    static func loadSettings() -> Settings {
        let loadedSettings: Settings = load("SettingsData.json", type: .container, createData: createSettings)
        return loadedSettings
    }
    
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
