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
        let container = try ModelContainer(for: Day.self, Settings.self, NotificationSettings.self)
        
        var itemFetchDescriptor = FetchDescriptor<Day>()
        
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
                let newDay = Day(id: day, text: settings.weekdaysText[day.weekday - 1],
                                   fgColor: settings.weekdaysFgColor[day.weekday - 1],
                                   bgColor: settings.weekdaysBgColor[day.weekday - 1])
                container.mainContext.insert(newDay)
            }
            
            day = day.dayAfter.noon
        }
        
        var settingsFetchDescriptor = FetchDescriptor<Settings>()
        settingsFetchDescriptor.fetchLimit = 1
        
        guard try container.mainContext.fetch(settingsFetchDescriptor).count == 0 else { return container }

        container.mainContext.insert(settings)
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
