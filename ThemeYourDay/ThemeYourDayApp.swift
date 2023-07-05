import SwiftUI
import SwiftData


@main
struct ThemeYourDayApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
        .modelContainer(appContainer)
    }
}

