import SwiftUI
import SwiftData


@main
struct ThemeYourDayApp: App {
    @State private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
        .modelContainer(appContainer)
    }
}

