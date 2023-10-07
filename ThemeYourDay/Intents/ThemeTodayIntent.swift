//
//  ThemeTodayIntent.swift
//  ThemeYourDay
//
//  Created by Christian on 03.10.23.
//

import AppIntents
import SwiftData

struct ThemeTodayIntent: AppIntent {
    
    let today = Date().noon
    static var title: LocalizedStringResource = "Theme today intent"
    
    @Parameter(title: "Theme text")
    var text: String
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let predicate = #Predicate<Day> { day in
            day.id.noon == today
        }
        
        let itemFetchDescriptor = FetchDescriptor<Day>()
        let loadedDays = try appContainer.mainContext.fetch(itemFetchDescriptor)
        if let day = try loadedDays.filter(predicate).first {
            day.text = text
        }
        
        /*if let day = try? appContainer.mainContext.fetch(.init(predicate: predicate)).first {
            day.text = text
        }*/
        return .result()
    }
}
