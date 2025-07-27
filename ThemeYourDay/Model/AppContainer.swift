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
        
        let fetchedSettings = try container.mainContext.fetch(settingsFetchDescriptor)

        if fetchedSettings.count == 1 {
            for loadedDay in loadedDays {
                let day = loadedDay.id
                if day.noon > Date().noon {
                    if let weekdayBgColor = fetchedSettings.first?.weekdaysBgColor[day.weekday - 1] {
                        if  weekdayBgColor != Day.defaultBgColor {
                            loadedDay.bgColor = weekdayBgColor
                        }
                    }
                }
            }
            return container
        }

        container.mainContext.insert(settings)
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
