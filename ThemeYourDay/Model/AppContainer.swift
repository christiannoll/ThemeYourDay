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
        let container = try ModelContainer(for: MyDay.self)
        
        // Make sure the persistent store is empty. If it's not, return the non-empty container.
        var itemFetchDescriptor = FetchDescriptor<MyDay>()
        itemFetchDescriptor.fetchLimit = 1
        
        guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else { return container }
        
        let day = Date().noon
        let settings = Settings()
        let newDay = MyDay(id: day, text: settings.weekdaysText[day.weekday - 1],
                         fgColor: settings.weekdaysFgColor[day.weekday - 1],
                         bgColor: settings.weekdaysBgColor[day.weekday - 1])
        
        container.mainContext.insert(object: newDay)
        
        // This code will only run if the persistent store is empty.
//        let items = [
//            Item(timestamp: Date()),
//            Item(timestamp: Date()),
//            Item(timestamp: Date())
//        ]
//
//        for item in items {
//            container.mainContext.insert(object: item)
//        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
