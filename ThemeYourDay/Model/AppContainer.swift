//
//  AppContainer.swift
//  ThemeYourDay
//
//  Created by Christian on 02.07.23.
//

import SwiftData
import Foundation

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: [MyDay.self, MySticker.self])
        
        var itemFetchDescriptor = FetchDescriptor<MyDay>()
        
        let endDate = Date().getNextMonth()?.getNextMonth()?.noon
        var day = Date().getPreviousMonth()?.noon ?? Date().noon
        var loadedDays = try container.mainContext.fetch(itemFetchDescriptor)
        let settings = Settings()
        
        while day != endDate {
            var loaded = false
            for loadedDay in loadedDays {
                if loadedDay.id.hasSame(.day, as: day) {
                    loaded = true
                    break
                }
            }
            
            if !loaded {
                let newDay = MyDay(id: day, text: settings.weekdaysText[day.weekday - 1],
                                   fgColor: settings.weekdaysFgColor[day.weekday - 1],
                                   bgColor: settings.weekdaysBgColor[day.weekday - 1])
                container.mainContext.insert(object: newDay)
            }
            
            day = day.dayAfter.noon
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
