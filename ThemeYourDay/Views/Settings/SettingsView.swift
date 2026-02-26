import SwiftUI

struct SettingsView: View {
    
    @Environment(ModelData.self) var modelData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("ThemeTemplate")) {
                    NavigationLink("BackgroundColors", destination: WeekSettingsView(weekSettingsType: .bgcolor))
                    NavigationLink("ForegroundColors", destination: WeekSettingsView(weekSettingsType: .fgcolor))
                    NavigationLink("Texts", destination: WeekSettingsView(weekSettingsType: .text))
                }
                NotificationSettingsView()
                Text("App-Version: \(Bundle.main.versionNumberWithBuild ?? "N/A")")
            }
            .navigationBarTitle("Settings", displayMode: .automatic)
            .navigationBarItems(
                trailing: Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }
            )
        }
    }
}

#Preview {
    SettingsView()
}
