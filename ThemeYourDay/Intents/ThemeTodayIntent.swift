import AppIntents
import SwiftData
import WidgetKit

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
        
        WidgetCenter.shared.reloadAllTimelines()
        
        /*if let day = try? appContainer.mainContext.fetch(.init(predicate: predicate)).first {
            day.text = text
        }*/
        return .result()
    }
}
