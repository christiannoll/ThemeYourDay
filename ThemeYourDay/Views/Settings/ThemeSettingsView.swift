import SwiftUI

struct ThemeSettingsView: View {
    var body: some View {
        Form {
            Section {
                NavigationLink("BackgroundColors", destination: WeekSettingsView(weekSettingsType: .bgcolor))
                NavigationLink("ForegroundColors", destination: WeekSettingsView(weekSettingsType: .fgcolor))
                NavigationLink("Texts", destination: WeekSettingsView(weekSettingsType: .text))
            }
        }
        .navigationTitle("ThemeTemplate")
    }
}
