import SwiftUI
import SwiftData


@main
struct ThemeYourDayApp: App {

    @State private var modelData = ModelData()
    @AppStorage("appearance") private var appearance: Appearance = .system

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
                .preferredColorScheme(appearance.colorScheme)
        }
        .modelContainer(appContainer)
    }
}

